#!/usr/bin/env nix-shell
#!nix-shell --pure -i python3 -p "python3.withPackages (ps: with ps; [ requests ])"

import json
import re
import requests
import sys

feature_versions = (8, 11, 16, 17, 21)
oses = ("mac", "linux")
types = ("jre", "jdk")
impls = ("openj9",)

arch_to_nixos = {
    "x64": ("x86_64",),
    "aarch64": ("aarch64",),
    "arm": ("armv6l", "armv7l"),
}

def get_sha256(url):
    resp = requests.get(url)
    if resp.status_code != 200:
        print("error: could not fetch checksum from url {}: code {}".format(url, resp.status_code), file=sys.stderr)
        sys.exit(1)
    return resp.text.strip().split(" ")[0]

def generate_sources(releases, feature_version, out):
    latest_version = None
    for release in releases:
        if release["prerelease"]: continue
        if not re.search("_openj9-", release["name"]): continue

        for asset in release["assets"]:
            match = re.match("ibm-semeru-open-(?P<image_type>[a-z]*)_(?P<architecture>[a-z0-9]*)_(?P<os>[a-z]*)_(?:(?P<major1>[0-9]*)u(?P<security1>[0-9]*)b(?P<build1>[0-9]*)|(?P<major2>[0-9]*)\\.(?P<minor2>[0-9]*)\\.(?P<security2>[0-9]*)_(?P<build2>[0-9]*))_(?P<jvm_impl>[a-z0-9]*)-[0-9]*\\.[0-9]*\\.[0-9]\\.tar\\.gz$", asset["name"])

            if not match: continue
            if match["os"] not in oses: continue
            if match["image_type"] not in types: continue
            if match["jvm_impl"] not in impls: continue
            if match["architecture"] not in arch_to_nixos: continue

            version = ".".join([
                match["major1"] or match["major2"],
                match["minor2"] or "0",
                match["security1"] or match["security2"]
            ])
            build = match["build1"] or match["build2"]

            if latest_version and latest_version != (version, build): continue
            latest_version = (version, build)

            arch_map = (
                out
                .setdefault(match["jvm_impl"], {})
                .setdefault(match["os"], {})
                .setdefault(match["image_type"], {})
                .setdefault(feature_version, {
                    "packageType": match["image_type"],
                    "vmType": match["jvm_impl"],
                })
            )

            for nixos_arch in arch_to_nixos[match["architecture"]]:
                arch_map[nixos_arch] = {
                    "url": asset["browser_download_url"],
                    "sha256": get_sha256(asset["browser_download_url"] + ".sha256.txt"),
                    "version": version,
                    "build": build,
                }

    return out


out = {}
for feature_version in feature_versions:
    resp = requests.get(f"https://api.github.com/repos/ibmruntimes/semeru{feature_version}-binaries/releases")

    if resp.status_code != 200:
        print("error: could not fetch data for release {} (code {}) {}".format(feature_version, resp.status_code, resp.content), file=sys.stderr)
        sys.exit(1)
    generate_sources(resp.json(), f"openjdk{feature_version}", out)

with open("sources.json", "w") as f:
    json.dump(out, f, indent=2, sort_keys=True)
    f.write('\n')
