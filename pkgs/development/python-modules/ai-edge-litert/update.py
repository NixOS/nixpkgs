#!/usr/bin/env nix-shell
#!nix-shell -i python -p "python3.withPackages (ps: [ ps.httpx ] )"

import json
import httpx
import re
import subprocess
from pathlib import Path
from typing import Dict, Optional
from collections import defaultdict


def get_metadata(package) -> Dict:
    response = httpx.get(
        f"https://pypi.org/pypi/{package}/json",
        headers={"user-agent": "nixpkgs/pypi-updater/unstable"},
    )
    return response.json()


def get_hash(url) -> str:
    result = subprocess.run(["nix-prefetch-url", url], stdout=subprocess.PIPE)
    base32_hash = result.stdout.decode().strip()
    result = subprocess.run(
        ["nix", "hash", "to-sri", "--type", "sha256", base32_hash],
        stdout=subprocess.PIPE,
    )
    sri_hash = result.stdout.decode().strip()
    return sri_hash


def get_platform(platform: str) -> Optional[str]:
    result = re.match(
        r"^(?P<platform>macosx|manylinux|win)(?:)[\d_]+(?P<arch>x86_64|aarch64|amd64|arm64)",
        platform,
    )
    if not result:
        raise RuntimeError(f"Unable to parse platform string: {platform}")

    platform = result.group("platform")
    if platform == "win":
        return

    system = {
        "macosx": "darwin",
        "manylinux": "linux",
    }[platform]

    try:
        arch = {
            "amd64": "x86_64",
            "arm64": "aarch64",
        }[result.group("arch")]
    except KeyError:
        arch = result.group("arch")

    return f"{arch}-{system}"


def get_python_version(python: str) -> str:
    result = re.match(r"^cp(?P<major>\d)(?P<minor>\d+)$", python)
    if not result:
        raise RuntimeError(f"Unable to disect python compat tag: {python}")

    return f"{result.group('major')}.{result.group('minor')}"


def main(package: str):
    metadata = get_metadata(package)

    info = metadata.get("info")
    if info is None:
        raise RuntimeError("Package metadata has no info attribute")

    version = info.get("version")
    assert not info.get("yanked"), (
        f"Latest release was yanked: {info.get('yanked_reason')}"
    )
    releases = metadata["releases"][version]

    out = {
        "version": version,
        "src": defaultdict(dict),
    }
    for release in releases:
        if release.get("packagetype") != "bdist_wheel":
            # the package expects the binary wheels
            continue

        print(json.dumps(release, indent=2))

        filename = release.get("filename")
        result = re.match(
            rf"(?P<pname>\w+)-{re.escape(version)}-(?P<python>\w+)-(?P<dist>\w+)-(?P<platform>\w+)\.whl$",
            filename,
        )
        if not result:
            raise RuntimeError(f"Unable to disect wheel filename: {filename}")

        platform = get_platform(result.group("platform"))
        if not platform:
            continue

        python_version = get_python_version(release["python_version"])

        out["src"][platform][python_version] = {
            "url": release.get("url"),
            "hash": get_hash(release.get("url")),
        }

    with open(Path(__file__).with_name("release.json"), "w") as fd:
        json.dump(out, fd, indent=2)


if __name__ == "__main__":
    main("ai-edge-litert")
