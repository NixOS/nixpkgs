#!/usr/bin/env python3
"""
Generate workload pack data (Nix expressions) from SDK workload manifests.

Usage:
  python3 generate-workload-data.py <major.minor>

Example:
  python3 generate-workload-data.py 10.0

The script builds the binary SDK for the given .NET version from nixpkgs
(using the current checkout) and reads its bundled workload manifests.

Generates data for all non-abstract workloads, resolved for all supported
RIDs (linux-x64, linux-arm64, osx-arm64).
"""

import base64
import functools
import json
import hashlib
import os
import re
import subprocess
import sys
import tempfile
import time
import urllib.error
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


def load_selected_manifests(selection: dict) -> dict:
    """Read only the manifest versions selected by the SDK's resolver."""
    catalog = {}
    for entry in selection["manifests"]:
        if not all(isinstance(entry.get(key), str) and entry[key]
                   for key in ("id", "path", "featureBand", "version")):
            raise ValueError(f"Invalid resolver manifest: {entry!r}")
        manifest_id = entry["id"].lower()
        if manifest_id in catalog:
            raise ValueError(f"Duplicate manifest from resolver: {manifest_id}")
        manifest = parse_manifest(Path(entry["path"]))
        catalog[manifest_id] = {
            "featureBand": entry["featureBand"],
            "version": entry["version"],
            "workloads": manifest.get("workloads", {}),
            "packs": manifest.get("packs", {}),
        }
    return catalog


def check_catalog_compatibility(first_name: str, first: dict, name: str, catalog: dict):
    differences = [
        manifest_id for manifest_id in sorted(first.keys() | catalog.keys())
        if first.get(manifest_id) != catalog.get(manifest_id)
    ]
    if differences:
        raise RuntimeError(
            f"Incompatible workload catalogs for {first_name} and {name}: "
            + ", ".join(differences)
            + ". Shared workload data cannot be generated for these SDKs."
        )


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
        raise RuntimeError(f"Required workload {workload_id!r} not found for {host_rid}")

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
            raise RuntimeError(
                f"Required pack {pack_id!r} not found for workload {workload_id!r} on {host_rid}"
            )

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


@functools.cache
def nuget_package_base_url() -> str:
    with urllib.request.urlopen("https://api.nuget.org/v3/index.json", timeout=30) as response:
        resources = json.load(response)["resources"]
    for resource in resources:
        if resource["@type"] == "PackageBaseAddress/3.0.0":
            return resource["@id"].rstrip("/")
    raise RuntimeError("NuGet service index has no PackageBaseAddress/3.0.0 resource")


@functools.cache
def fetch_nuget_hash(nuget_id: str, version: str, retries: int = 3, timeout: int = 30) -> str:
    """Fetch a required NuGet package and compute its SRI hash."""
    package_id = nuget_id.lower()
    package_version = version.lower()
    url = f"{nuget_package_base_url()}/{package_id}/{package_version}/{package_id}.{package_version}.nupkg"
    print(f"  Fetching {nuget_id} {version}...", file=sys.stderr)
    req = urllib.request.Request(
        url, headers={"User-Agent": "nixpkgs-workload-gen/1.0"}
    )
    for attempt in range(1, retries + 1):
        try:
            # Match binary/update.sh's fast path, with a content-hash fallback.
            head = urllib.request.Request(url, headers=req.headers, method="HEAD")
            with urllib.request.urlopen(head, timeout=timeout) as response:
                encoded = response.headers.get("x-ms-meta-sha512")
                if encoded:
                    if len(base64.b64decode(encoded, validate=True)) != 64:
                        raise ValueError(f"Invalid NuGet SHA-512 metadata for {nuget_id} {version}")
                    return "sha512-" + encoded
            with urllib.request.urlopen(req, timeout=timeout) as resp:
                digest = hashlib.file_digest(resp, "sha512").digest()
            break
        except urllib.error.HTTPError as e:
            e.close()
            if e.code == 404:
                raise RuntimeError(
                    f"Required package {nuget_id} {version} unavailable (HTTP 404): {url}"
                ) from e
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
    sri = "sha512-" + base64.b64encode(digest).decode()
    return sri


SUPPORTED_RIDS = ["linux-x64", "linux-arm64", "osx-arm64"]


def generate_nix(
    workload_ids: list[str],
    workloads: dict,
    packs: dict,
    band: str,
    manifest_versions: dict | None = None,
    feature_bands: dict | None = None,
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
        try:
            p["hash"] = fetch_nuget_hash(p["nugetId"], p["version"])
        except (RuntimeError, urllib.error.URLError, TimeoutError) as error:
            affected = [
                f"{wid} ({rid})" for (rid, wid), pack_list in all_resolved.items()
                if any((pack["nugetId"], pack["version"]) == key for pack in pack_list)
            ]
            raise RuntimeError(f"{error}; required by {', '.join(affected)}") from error

    # Generate Nix
    lines = []
    lines.append("# Auto-generated workload pack data. Do not edit.")
    lines.append(f"# Generated by generate-workload-data.py for SDK band {band}")
    lines.append("{")
    lines.append(f'  sdkBand = "{band}";')
    lines.append("  featureBands = {")
    for sdk_version, feature_band in sorted((feature_bands or {}).items()):
        lines.append(f'    "{sdk_version}" = "{feature_band}";')
    lines.append("  };")
    lines.append("  manifestVersions = {")
    for manifest_id, version in sorted((manifest_versions or {}).items()):
        lines.append(f'    "{manifest_id}" = "{version}";')
    lines.append("  };")
    lines.append("")
    lines.append("  # All pack hashes (keyed by lowercase pname/version)")
    lines.append("  packHashes = {")
    for key in sorted(unique_packs.keys()):
        p = unique_packs[key]
        nix_key = f"{p['nugetId']}.{p['version']}".lower()
        lines.append(f'    "{nix_key}" = {{')
        lines.append(f'      pname = "{p["nugetId"]}";')
        lines.append(f'      version = "{p["version"]}";')
        lines.append(f'      kind = "{p["kind"]}";')
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


def discover_sdks(dotnet_version: str) -> list[dict]:
    directory = Path(__file__).resolve().parent
    result = subprocess.run(
        [
            "nix-instantiate", "--eval", "--strict", "--json", "--read-write-mode",
            str(directory / "workload-manifest-resolver" / "sdks.nix"),
            "--arg", "pkgs", f"import {directory.parents[3]} {{}}",
            "--argstr", "channel", dotnet_version,
        ],
        check=True, stdout=subprocess.PIPE, text=True,
    )
    sdks = json.loads(result.stdout)
    if not sdks:
        raise RuntimeError(f"No SDKs found for .NET {dotnet_version}")
    # Compare binary SDKs first; aliases of the same unwrapped SDK need no extra build.
    sdks.sort(key=lambda sdk: (not sdk["name"].endswith("-bin"), sdk["name"]))
    unique = {}
    for sdk in sdks:
        unique.setdefault(sdk["sdkDrv"], sdk)
    return list(unique.values())


def read_sdk_catalog(sdk: dict) -> tuple[dict, str]:
    print(f"Resolving manifests for {sdk['name']} ({sdk['version']})", file=sys.stderr)
    with tempfile.TemporaryDirectory(prefix="workload-resolver-") as temporary:
        root = Path(temporary) / "resolver"
        subprocess.run(
            ["nix-store", "--realise", sdk["resolverDrv"], "--add-root", str(root), "--indirect"],
            check=True, stdout=subprocess.DEVNULL,
        )
        result = subprocess.run(
            [str(root / "bin" / "dotnet-workload-manifest-resolver"), sdk["sdkRoot"], sdk["version"]],
            check=True, stdout=subprocess.PIPE, text=True,
        )
        selection = json.loads(result.stdout)
        if selection["sdkVersion"] != sdk["version"]:
            raise ValueError(f"Resolver returned the wrong SDK version for {sdk['name']}")
        return load_selected_manifests(selection), selection["sdkFeatureBand"]


def validate_workload_channel(directory: Path, version: str):
    if not re.fullmatch(r"[0-9]+\.[0-9]+", version) or not (directory / f"{version}.nix").is_file():
        raise ValueError(f"No workload data registered for .NET {version!r}")


def generate_workload_data(dotnet_version: str) -> str:
    validate_workload_channel(Path(__file__).resolve().parent / "workloads", dotnet_version)
    sdks = discover_sdks(dotnet_version)
    catalog, band = read_sdk_catalog(sdks[0])
    feature_bands = {sdks[0]["version"]: band}
    for sdk in sdks[1:]:
        other, other_band = read_sdk_catalog(sdk)
        check_catalog_compatibility(sdks[0]["name"], catalog, sdk["name"], other)
        feature_bands[sdk["version"]] = other_band

    workloads, packs, manifest_versions = {}, {}, {}
    for manifest_id, manifest in catalog.items():
        workloads.update(manifest["workloads"])
        packs.update(manifest["packs"])
        manifest_versions[manifest_id] = f"{manifest['featureBand']}/{manifest['version']}"

    workload_ids = [
        wid
        for wid, wdef in workloads.items()
        if not wdef.get("abstract") and not wdef.get("redirect-to")
    ]

    print(f"Resolving workloads: {workload_ids}", file=sys.stderr)

    return generate_nix(workload_ids, workloads, packs, band, manifest_versions, feature_bands)


def update_workload_data(directory: Path, versions: list[str]):
    for version in versions:
        validate_workload_channel(directory, version)
    with tempfile.TemporaryDirectory(prefix=".workloads-", dir=directory) as temporary:
        for version in versions:
            print(f"=== Generating workload data for .NET {version} ===", file=sys.stderr)
            staged = Path(temporary) / f"{version}.nix"
            staged.write_text(generate_workload_data(version) + "\n")
            subprocess.run(["nixfmt", str(staged)], check=True)
            subprocess.run(
                ["nix-instantiate", "--eval", "--strict", "--json", str(staged)],
                check=True, stdout=subprocess.DEVNULL,
            )
        for version in versions:
            os.replace(Path(temporary) / f"{version}.nix", directory / f"{version}.nix")


def main():
    directory = Path(__file__).resolve().parent / "workloads"
    if sys.argv[1:2] == ["--write"]:
        versions = sys.argv[2:] or sorted(path.stem for path in directory.glob("*.nix"))
        update_workload_data(directory, list(dict.fromkeys(versions)))
    elif len(sys.argv) == 2:
        print(generate_workload_data(sys.argv[1]))
    else:
        raise ValueError("Usage: generate-workload-data.py [--write] <major.minor>")


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, ValueError, OSError, subprocess.CalledProcessError) as error:
        print(f"Workload generation failed: {error}", file=sys.stderr)
        sys.exit(1)
