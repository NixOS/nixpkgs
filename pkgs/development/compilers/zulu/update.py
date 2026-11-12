#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3

"""Update sources/<feature version>.json from the Azul metadata API.

Usage: ./update.py [FEATURE_VERSION...]   (defaults to all existing sources)
"""

import base64
import json
import sys
import urllib.parse
import urllib.request
from pathlib import Path

API = "https://api.azul.com/metadata/v1/zulu/packages/"
SOURCES = Path(__file__).parent / "sources"

# nix system -> (os, arch, lib_c_type) as understood by the Azul API
PLATFORMS = {
    "x86_64-linux": ("linux", "x64", "glibc"),
    "aarch64-linux": ("linux", "aarch64", "glibc"),
    "aarch64-darwin": ("macos", "aarch64", None),
}

# key in sources/*.json -> value of the javafx_bundled API parameter
PACKAGES = {
    "jdk": "false",
    "fx": "true",
}


def get(url: str):
    request = urllib.request.Request(url, headers={"User-Agent": "nixpkgs-zulu-updater"})
    with urllib.request.urlopen(request) as response:
        return json.load(response)


def latest(feature_version: str, os: str, arch: str, lib_c_type: str | None, javafx: str) -> dict:
    params = {
        "java_version": feature_version,
        "os": os,
        "arch": arch,
        "archive_type": "tar.gz",
        "java_package_type": "jdk",
        "javafx_bundled": javafx,
        "crac_supported": "false",
        "release_status": "ga",
        "availability_types": "CA",
        "latest": "true",
        "page_size": "1",
    }
    if lib_c_type:
        params["lib_c_type"] = lib_c_type

    packages = get(API + "?" + urllib.parse.urlencode(params))
    if not packages:
        raise RuntimeError(f"no zulu {feature_version} package for {os}/{arch} (javafx={javafx})")

    package = get(API + packages[0]["package_uuid"])
    sha256 = bytes.fromhex(package["sha256_hash"])
    return {
        # distro_version is zero-padded (21.54.109.0), so take it from the file name instead
        "zuluVersion": package["name"].removeprefix("zulu").split("-", 1)[0],
        "jdkVersion": ".".join(map(str, package["java_version"])),
        "url": package["download_url"],
        "hash": "sha256-" + base64.b64encode(sha256).decode(),
    }


def update(feature_version: str) -> None:
    sources = {
        name: {
            system: latest(feature_version, *platform, javafx)
            for system, platform in PLATFORMS.items()
        }
        for name, javafx in PACKAGES.items()
    }

    path = SOURCES / f"{feature_version}.json"
    path.write_text(json.dumps(sources, indent=2) + "\n")
    for name, dists in sources.items():
        versions = sorted({dist["jdkVersion"] for dist in dists.values()})
        print(f"zulu{feature_version} {name}: {', '.join(versions)}", file=sys.stderr)


def main() -> None:
    feature_versions = sys.argv[1:] or sorted(path.stem for path in SOURCES.glob("*.json"))
    for feature_version in feature_versions:
        update(feature_version)


if __name__ == "__main__":
    main()
