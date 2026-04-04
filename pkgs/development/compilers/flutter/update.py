#!/usr/bin/env nix-shell
# !nix-shell -i python3 -p python3Packages.pyyaml nix-update dart

import argparse
import json
import logging
import shutil
import stat
import subprocess
import sys
import tempfile
import urllib.request
from pathlib import Path
from typing import Any, NoReturn

import yaml

FLUTTER_RELEASES_URL = (
    "https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json"
)

logging.basicConfig(
    level=logging.INFO,
    format="%(levelname)s: %(message)s",
    stream=sys.stderr,
)
logger = logging.getLogger(__name__)


def fatal_error(msg: str) -> NoReturn:
    logger.error(msg)
    sys.exit(1)


def run_command(cmd: list[str], cwd: Path | None = None) -> str:
    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            cwd=cwd,
            check=True,
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        fatal_error(f"Command failed: {' '.join(cmd)}\n{e.stderr.strip()}")


def fetch_url(url: str) -> bytes:
    with urllib.request.urlopen(url, timeout=30) as response:
        return response.read()


def get_nixpkgs_root() -> Path:
    return Path(run_command(["git", "rev-parse", "--show-toplevel"]))


def run_nix_eval(cmds: list[str]) -> str:
    return run_command(["nix", "eval", "--json", "--impure", *cmds])


def run_nix_prefetch(url: str, unpack: bool = False) -> str:
    args = ["nix", "store", "prefetch-file", "--json"]
    if unpack:
        args.append("--unpack")
    args.append(url)

    output = run_command(args)

    hash_value = json.loads(output).get("hash")
    if not hash_value:
        fatal_error(f"No hash in prefetch output: {output}")
    return hash_value


def get_version_str(flutter_version: str) -> str:
    return "_".join(flutter_version.split(".")[:2])


def requires_engine_hash(flutter_version: str) -> bool:
    parts = flutter_version.split(".")
    if len(parts) < 2:
        return False
    major, minor = int(parts[0]), int(parts[1])
    return major > 3 or (major == 3 and minor >= 41)


def get_version_data(
    target_version: str | None = None, channel: str | None = None
) -> tuple[str, str, str, str]:
    channel = channel or "stable"
    releases_data = json.loads(fetch_url(FLUTTER_RELEASES_URL).decode("utf-8"))

    if not target_version:
        release_hash = releases_data["current_release"].get(channel)
        if not release_hash:
            fatal_error(f"Channel '{channel}' not found in current releases")
        release = next(
            (r for r in releases_data["releases"] if r["hash"] == release_hash),
            None,
        )
    else:
        release = next(
            (r for r in releases_data["releases"] if r["version"] == target_version),
            None,
        )

    if not release:
        fatal_error(f"Version {target_version or 'latest'} not found in '{channel}'")

    target_version = release["version"]
    release_hash = release["hash"]
    dart_version = release.get("dart_sdk_version")

    if not dart_version:
        fatal_error(f"No dart_sdk_version found for {target_version}")

    if " " in dart_version:
        dart_version = dart_version.split(" ")[2].strip("()")

    engine_url = f"https://github.com/flutter/flutter/raw/{release_hash}/bin/internal/engine.version"
    engine_version = fetch_url(engine_url).decode("utf-8").strip()

    return target_version, engine_version, dart_version, channel


def extract_nix_url(output: str) -> str:
    try:
        urls = json.loads(output)
        return urls[0] if isinstance(urls, list) and urls else ""
    except json.JSONDecodeError:
        return output.strip('[]"').replace("\\", "")


def get_dart_hashes(flutter_version: str) -> dict[str, str]:
    version_str = get_version_str(flutter_version)
    platforms = ["x86_64-darwin", "aarch64-darwin"]
    if not requires_engine_hash(flutter_version):
        platforms += ["x86_64-linux", "aarch64-linux"]
    dart_hashes = {}

    for system in platforms:
        cmds = [
            "--file",
            ".",
            f"flutterPackages-bin.v{version_str}.passthru.scope.dart.src.drvAttrs.urls",
            "--system",
            system,
        ]
        output = run_nix_eval(cmds)
        url = extract_nix_url(output)

        if not url:
            fatal_error(f"No Dart SDK URL found for {system}")

        dart_hashes[system] = run_nix_prefetch(url)

    return dart_hashes


def get_flutter_hash(flutter_version: str) -> str:
    version_str = get_version_str(flutter_version)
    cmds = [
        "--file",
        ".",
        f"flutterPackages-bin.v{version_str}.passthru.scope.flutterSource.drvAttrs.urls",
    ]
    output = run_nix_eval(cmds)
    url = extract_nix_url(output)

    if not url:
        fatal_error(f"No Flutter source URL found for {flutter_version}")

    return run_nix_prefetch(url, unpack=True)


def get_artifact_hashes(flutter_version: str, engine_version: str) -> dict[str, str]:
    version_str = get_version_str(flutter_version)
    nixpkgs_root = get_nixpkgs_root()

    expr = (
        f"let pkgs = import {nixpkgs_root} {{ }}; "
        "in (builtins.map (x: x.path.url) "
        f'pkgs.flutterPackages-bin."v{version_str}".passthru.scope.all-artifacts)'
    )

    output = run_nix_eval(["--expr", expr])

    artifacts = json.loads(output)

    if not isinstance(artifacts, list):
        fatal_error("Artifacts is not a list")

    artifact_hashes = {}
    for url in artifacts:
        if engine_version not in url:
            continue

        path_parts = url.split("/")

        hash_idx = path_parts.index(engine_version)
        path_key = "/".join(path_parts[hash_idx + 1 :])

        if path_key not in artifact_hashes:
            artifact_hashes[path_key] = run_nix_prefetch(url)

    return artifact_hashes


def get_pubspec_lock(flutter_version: str) -> dict[str, Any]:
    version_str = get_version_str(flutter_version)
    target = f".#flutterPackages-bin.v{version_str}.scope.flutterSource"

    flutter_src_str = run_command([
        "nix",
        "build",
        "--no-link",
        "--print-out-paths",
        target,
    ])
    if not flutter_src_str:
        fatal_error(f"No Flutter source path found for {flutter_version}")

    flutter_src = Path(flutter_src_str)

    with tempfile.TemporaryDirectory(prefix="flutter_src_") as temp_dir_name:
        temp_dir = Path(temp_dir_name)
        flutter_copy = temp_dir / "flutter"

        shutil.copytree(flutter_src, flutter_copy, symlinks=False)

        for path_item in flutter_copy.rglob("*"):
            path_item.chmod(path_item.stat().st_mode | stat.S_IWUSR)
        flutter_copy.chmod(flutter_copy.stat().st_mode | stat.S_IWUSR)

        flutter_tools_path = flutter_copy / "packages" / "flutter_tools"
        if not flutter_tools_path.exists():
            fatal_error(f"flutter_tools not found at {flutter_tools_path}")

        run_command(["dart", "pub", "get"], cwd=flutter_tools_path)

        pubspec_lock_path = flutter_tools_path / "pubspec.lock"
        if not pubspec_lock_path.exists():
            fatal_error(f"pubspec.lock not found at {pubspec_lock_path}")

        with pubspec_lock_path.open("r", encoding="utf-8") as f:
            return yaml.safe_load(f)


def save_json(data: dict[str, Any], output_path: Path) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, sort_keys=True)
        f.write("\n")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Update Flutter data.json for nixpkgs",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "--version",
        type=str,
        help="Specific Flutter version (e.g., 3.41.4). Uses latest from channel if omitted.",
    )
    parser.add_argument(
        "--channel",
        type=str,
        default="stable",
        choices=["stable", "beta"],
        help="Release channel (default: stable)",
    )

    args = parser.parse_args()

    logger.info("Fetching version data...")
    flutter_version, engine_version, dart_version, channel = get_version_data(
        args.version, args.channel
    )

    logger.info(f"Target Flutter Version: {flutter_version}")
    logger.info(f"Engine Version (commit): {engine_version}")
    logger.info(f"Dart Version: {dart_version}")

    version_str = get_version_str(flutter_version)
    version_dir = Path(__file__).resolve().parent / "versions" / version_str
    output_path = version_dir / "data.json"

    has_engine_hash = requires_engine_hash(flutter_version)

    data = {
        "version": flutter_version,
        "engineVersion": engine_version,
        "channel": channel,
        "dartVersion": dart_version,
        "dartHash": {},
        "flutterHash": "",
        "artifactHashes": {},
        "pubspecLock": {},
    }

    save_json(data, output_path)

    logger.info("Fetching Dart hashes...")
    data["dartHash"] = get_dart_hashes(flutter_version)

    if has_engine_hash:
        data["dartHash"]["linux"] = (
            "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
        )
        save_json(data, output_path)
        logger.info("Running nix-update for dart hash...")
        run_command([
            "nix-update",
            "--version",
            "skip",
            "--override-filename",
            str(output_path),
            f"flutterPackages-source.v{version_str}.passthru.scope.dart",
        ])
        with output_path.open("r", encoding="utf-8") as f:
            updated_data = json.load(f)
        data["dartHash"]["linux"] = updated_data.get("dartHash")["linux"]

        data["engineHash"] = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
        save_json(data, output_path)
        logger.info("Running nix-update for engine hash...")
        run_command([
            "nix-update",
            "--version",
            "skip",
            "--override-filename",
            str(output_path),
            f"flutterPackages-source.v{version_str}.passthru.scope.engine",
        ])
        with output_path.open("r", encoding="utf-8") as f:
            updated_data = json.load(f)
        data["engineHash"] = updated_data.get("engineHash")

    logger.info("Fetching Flutter source hash...")
    data["flutterHash"] = get_flutter_hash(flutter_version)

    logger.info("Fetching artifact hashes...")
    data["artifactHashes"] = get_artifact_hashes(flutter_version, engine_version)

    save_json(data, output_path)

    logger.info("Generating pubspec.lock...")
    data["pubspecLock"] = get_pubspec_lock(flutter_version)

    save_json(data, output_path)

    logger.info(f"Update complete. Data written to {output_path}")


if __name__ == "__main__":
    main()
