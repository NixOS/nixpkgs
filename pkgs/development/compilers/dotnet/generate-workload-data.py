#!/usr/bin/env python3
"""
Generate workload pack data (Nix expressions) from SDK workload manifests.

Usage:
  python3 generate-workload-data.py <major.minor>

Example:
  python3 generate-workload-data.py 9.0

The script builds the binary SDK for the given .NET version from nixpkgs
(using the current checkout) and reads its bundled workload manifests.

Generates data for all non-abstract workloads, resolved for all supported
RIDs (linux-x64, linux-arm64, osx-x64, osx-arm64).
"""

import base64
import json
import hashlib
import re
import subprocess
import sys
import time
import urllib.request
from pathlib import Path


def parse_manifest(path: Path) -> dict:
    """Parse a WorkloadManifest.json with comments and trailing commas."""
    text = path.read_text()
    # Remove single-line comments
    text = re.sub(r"//[^\n]*", "", text)
    # Remove multi-line comments
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.DOTALL)
    # Remove trailing commas before } or ]
    text = re.sub(r",(\s*[}\]])", r"\1", text)
    return json.loads(text)


def load_all_manifests(sdk_path: Path, band: str) -> tuple[dict, dict, dict]:
    """Load all workload manifests for a band, returning merged workloads, packs, and manifest sources."""
    manifests_dir = sdk_path / "share" / "dotnet" / "sdk-manifests" / band
    all_workloads = {}
    all_packs = {}
    manifest_sources = {}  # manifest-id -> version

    for manifest_dir in sorted(manifests_dir.iterdir()):
        if not manifest_dir.is_dir():
            continue
        manifest_id = manifest_dir.name
        # Find the version subdirectory
        for version_dir in manifest_dir.iterdir():
            if not version_dir.is_dir():
                continue
            manifest_file = version_dir / "WorkloadManifest.json"
            if manifest_file.exists():
                manifest = parse_manifest(manifest_file)
                manifest_sources[manifest_id] = version_dir.name
                all_workloads.update(manifest.get("workloads", {}))
                all_packs.update(manifest.get("packs", {}))

    return all_workloads, all_packs, manifest_sources


RID_GRAPH = {
    "linux-x64": ["linux", "unix", "any"],
    "linux-arm64": ["linux", "unix", "any"],
    "linux-musl-x64": ["linux-musl", "linux", "unix", "any"],
    "linux-musl-arm64": ["linux-musl", "linux", "unix", "any"],
    "osx-x64": ["osx", "unix", "any"],
    "osx-arm64": ["osx", "unix", "any"],
    "win-x64": ["win", "any"],
    "win-arm64": ["win", "any"],
    "win-x86": ["win", "any"],
}


def resolve_rid(alias_to: dict, host_rid: str) -> str | None:
    """Resolve an alias-to mapping for a host RID using the RID graph."""
    if host_rid in alias_to:
        return alias_to[host_rid]
    for parent_rid in RID_GRAPH.get(host_rid, []):
        if parent_rid in alias_to:
            return alias_to[parent_rid]
    return None


def resolve_workload_packs(
    workload_id: str,
    workloads: dict,
    packs: dict,
    host_rid: str,
    visited: set | None = None,
) -> list[dict]:
    """Resolve all packs for a workload, following extends transitively."""
    if visited is None:
        visited = set()
    if workload_id in visited:
        return []
    visited.add(workload_id)

    wdef = workloads.get(workload_id)
    if wdef is None:
        print(f"WARNING: workload {workload_id!r} not found", file=sys.stderr)
        return []

    # Check platform restriction
    platforms = wdef.get("platforms", [])
    if platforms and host_rid not in platforms:
        return []

    result = []

    # Resolve extends first
    for base_id in wdef.get("extends", []):
        result.extend(
            resolve_workload_packs(base_id, workloads, packs, host_rid, visited)
        )

    # Then this workload's own packs
    for pack_id in wdef.get("packs", []):
        pdef = packs.get(pack_id)
        if pdef is None:
            print(f"WARNING: pack {pack_id!r} not found", file=sys.stderr)
            continue

        version = pdef["version"]
        kind = pdef.get("kind", "library")

        alias_to = pdef.get("alias-to")
        if alias_to:
            nuget_id = resolve_rid(alias_to, host_rid)
            if nuget_id is None:
                # Pack not available on this platform
                continue
        else:
            nuget_id = pack_id

        result.append(
            {
                "packId": pack_id,
                "nugetId": nuget_id,
                "version": version,
                "kind": kind.lower(),
            }
        )

    # Deduplicate by nugetId+version
    seen = set()
    deduped = []
    for p in result:
        key = (p["nugetId"], p["version"])
        if key not in seen:
            seen.add(key)
            deduped.append(p)

    return deduped


def fetch_nuget_hash(nuget_id: str, version: str, retries: int = 3, timeout: int = 30) -> str | None:
    """Fetch a NuGet package and compute its SRI hash. Returns None on 404."""
    url = f"https://www.nuget.org/api/v2/package/{nuget_id}/{version}"
    print(f"  Fetching {nuget_id} {version}...", file=sys.stderr)
    req = urllib.request.Request(
        url, headers={"User-Agent": "nixpkgs-workload-gen/1.0"}
    )
    for attempt in range(1, retries + 1):
        try:
            with urllib.request.urlopen(req, timeout=timeout) as resp:
                data = resp.read()
            break
        except urllib.error.HTTPError as e:
            if e.code == 404:
                print(
                    f"  WARNING: {nuget_id} {version} not found on NuGet (404), skipping",
                    file=sys.stderr,
                )
                return None
            if attempt < retries:
                print(f"  Retrying ({attempt}/{retries}) after HTTP {e.code}...", file=sys.stderr)
                time.sleep(2 ** attempt)
                continue
            raise
        except (urllib.error.URLError, TimeoutError):
            if attempt < retries:
                print(f"  Retrying ({attempt}/{retries}) after network error...", file=sys.stderr)
                time.sleep(2 ** attempt)
                continue
            raise
    sha512 = hashlib.sha512(data).digest()
    sri = "sha512-" + base64.b64encode(sha512).decode()
    return sri


SUPPORTED_RIDS = ["linux-x64", "linux-arm64", "osx-x64", "osx-arm64"]


def generate_nix(
    workload_ids: list[str],
    workloads: dict,
    packs: dict,
    band: str,
) -> str:
    """Generate a Nix expression for workload packs across all supported RIDs."""
    # Resolve for all RIDs
    all_resolved = {}  # (rid, wid) -> [pack]
    for rid in SUPPORTED_RIDS:
        for wid in workload_ids:
            resolved = resolve_workload_packs(wid, workloads, packs, rid)
            all_resolved[(rid, wid)] = resolved

    # Collect all unique packs across all RIDs
    unique_packs = {}
    for pack_list in all_resolved.values():
        for p in pack_list:
            key = (p["nugetId"], p["version"])
            if key not in unique_packs:
                unique_packs[key] = p

    # Fetch hashes
    for key, p in sorted(unique_packs.items()):
        p["hash"] = fetch_nuget_hash(p["nugetId"], p["version"])
    # Remove packs that couldn't be fetched (404)
    missing = {k for k, p in unique_packs.items() if p["hash"] is None}
    if missing:
        print(f"  Skipping {len(missing)} unavailable packs", file=sys.stderr)
        unique_packs = {
            k: p for k, p in unique_packs.items() if p["hash"] is not None
        }
        # Also remove from per-RID mappings
        for key, pack_list in all_resolved.items():
            all_resolved[key] = [
                p for p in pack_list if (p["nugetId"], p["version"]) not in missing
            ]

    # Generate Nix
    lines = []
    lines.append("# Auto-generated workload pack data. Do not edit.")
    lines.append(f"# Generated by generate-workload-data.py for SDK band {band}")
    lines.append("{")
    lines.append(f'  sdkBand = "{band}";')
    lines.append("")
    lines.append("  # All pack hashes (keyed by lowercase pname/version)")
    lines.append("  packHashes = {")
    for key in sorted(unique_packs.keys()):
        p = unique_packs[key]
        nix_key = f"{p['nugetId']}.{p['version']}".lower()
        lines.append(f'    "{nix_key}" = {{')
        lines.append(f'      pname = "{p["nugetId"]}";')
        lines.append(f'      version = "{p["version"]}";')
        lines.append(f'      hash = "{p["hash"]}";')
        lines.append("    };")
    lines.append("  };")
    lines.append("")

    # Per-RID workload -> pack mappings
    lines.append("  workloadPackNames = {")
    for rid in SUPPORTED_RIDS:
        lines.append(f'    "{rid}" = {{')
        for wid in sorted(workload_ids):
            pack_list = all_resolved.get((rid, wid), [])
            if pack_list:
                pack_keys = [
                    f'"{p["nugetId"]}.{p["version"]}"'.lower() for p in pack_list
                ]
                lines.append(f'      "{wid}" = [')
                for pk in pack_keys:
                    lines.append(f"        {pk}")
                lines.append("      ];")
        lines.append("    };")
    lines.append("  };")
    lines.append("}")

    return "\n".join(lines)


def resolve_sdk_path(dotnet_version: str) -> Path:
    """Build the binary SDK from nixpkgs and return its store path."""
    # Map version to the nixpkgs attribute for the binary (unwrapped) SDK.
    # We use the _1xx-bin variant because it has the baseline manifests.
    major, minor = dotnet_version.split(".")
    attr = f"dotnetCorePackages.sdk_{major}_{minor}_1xx-bin.unwrapped"

    nixpkgs_dir = (
        Path(__file__).resolve().parents[4]
    )  # pkgs/development/compilers/dotnet -> repo root
    print(f"Building {attr} from {nixpkgs_dir}...", file=sys.stderr)

    result = subprocess.run(
        ["nix-build", str(nixpkgs_dir), "-A", attr, "--no-out-link"],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print(result.stderr, file=sys.stderr)
        raise RuntimeError(f"Failed to build {attr}")

    store_path = result.stdout.strip()
    print(f"SDK path: {store_path}", file=sys.stderr)
    return Path(store_path)


def main():
    if len(sys.argv) < 2:
        print(__doc__, file=sys.stderr)
        sys.exit(1)

    dotnet_version = sys.argv[1]

    sdk_path = resolve_sdk_path(dotnet_version)

    # Detect SDK band
    sdk_manifests = sdk_path / "share" / "dotnet" / "sdk-manifests"
    bands = sorted(
        [d.name for d in sdk_manifests.iterdir() if d.is_dir()], reverse=True
    )
    band = bands[0]  # Use the latest band
    print(f"Using SDK band: {band}", file=sys.stderr)

    workloads, packs, manifest_sources = load_all_manifests(sdk_path, band)

    workload_ids = [
        wid
        for wid, wdef in workloads.items()
        if not wdef.get("abstract") and not wdef.get("redirect-to")
    ]

    print(f"Resolving workloads: {workload_ids}", file=sys.stderr)

    nix_output = generate_nix(
        workload_ids,
        workloads,
        packs,
        band,
    )

    print(nix_output)


if __name__ == "__main__":
    main()
