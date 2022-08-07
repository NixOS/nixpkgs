#!/usr/bin/env nix-shell
#!nix-shell --pure -i python3 -p "python3.withPackages (ps: with ps; [ requests ])"

import json
import re
import requests
import sys

releases = ("semeru8", "semeru11", "semeru17", "semeru18")
oses = ("linux", "mac")
variants = ("openj9",)
types = ("jre", "jdk")

arch_to_nixos = {
    "x64": ("x86_64",),
    "aarch64": ("aarch64",),
    "ppc64le": ("powerpc64le",),
}


def generate_sources(release, assets):
    assets = assets["assets"]
    out = {}

    for asset in assets:
        name = asset["name"]
        url = asset["browser_download_url"]

        if not name.endswith(".tar.gz.json"):
            continue

        resp = requests.get(url)
        if resp.status_code != 200:
            print(
                f"error: could not fetch data for asset {name} (code {resp.status_code})",
                file=sys.stderr,
            )
            sys.exit(1)

        info = resp.json()
        if info["os"] not in oses:
            continue
        if info["arch"] not in arch_to_nixos:
            continue
        if info["variant"] not in variants:
            continue
        if info["binary_type"] not in types:
            continue

        # examples: 11.0.1+13, 8.0.222+10
        version, build = info["version"]["semver"].split("+")

        type_map = out.setdefault(info["os"], {})
        impl_map = type_map.setdefault(info["binary_type"], {})
        arch_map = impl_map.setdefault(
            info["variant"],
            {
                "packageType": info["binary_type"],
                "vmType": info["variant"],
            },
        )
        for nixos_arch in arch_to_nixos[info["arch"]]:
            arch_map[nixos_arch] = {
                "url": url.removesuffix(".json"),
                "sha256": info["sha256"],
                "version": version,
                "build": build,
            }

    return out


out = {}
for release in releases:
    resp = requests.get(
        f"https://api.github.com/repos/ibmruntimes/{release}-binaries/releases/latest"
    )
    if resp.status_code != 200:
        print(
            f"error: could not fetch data for release {release} (code {resp.status_code})",
            file=sys.stderr,
        )
        sys.exit(1)
    out[release] = generate_sources(release, resp.json())

with open("sources.json", "w") as f:
    json.dump(out, f, indent=2, sort_keys=True)
    f.write("\n")
