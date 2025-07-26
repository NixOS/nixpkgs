#!/usr/bin/env nix-shell
#!nix-shell --pure -i python3 -p "python3.withPackages (ps: with ps; [ requests ])"

import json
import re
import requests
import sys

if len(sys.argv) < 2:
    print("Pass a GitHub token as the first parameter to this script to avoid rate limits")
    GITHUB_TOKEN = None
else:
    GITHUB_TOKEN = sys.argv[1]

feature_versions = (8, 11, 17, 21, 23, 24)
ea_feature_versions = (25,)
oses = ("mac", "linux", "alpine-linux")
types = ("jre", "jdk")
impls = ("hotspot",)

arch_to_nixos = {
    "x64": ("x86_64",),
    "aarch64": ("aarch64",),
    "arm": ("armv6l", "armv7l"),
    "ppc64le": ("powerpc64le",),
    "riscv64": ("riscv64",),
}

def generate_sources(assets, feature_version, out):
    for asset in assets:
        binary = asset["binary"]
        if binary["os"] not in oses: continue
        if binary["image_type"] not in types: continue
        if binary["jvm_impl"] not in impls: continue
        if binary["heap_size"] != "normal": continue
        if binary["architecture"] not in arch_to_nixos: continue

        version = ".".join(str(v) for v in [
            asset["version"]["major"],
            asset["version"]["minor"],
            asset["version"]["security"]
        ])
        build = str(asset["version"]["build"])

        arch_map = (
            out
            .setdefault(binary["jvm_impl"], {})
            .setdefault(binary["os"], {})
            .setdefault(binary["image_type"], {})
            .setdefault(feature_version, {
                "packageType": binary["image_type"],
                "vmType": binary["jvm_impl"],
            })
        )

        for nixos_arch in arch_to_nixos[binary["architecture"]]:
            arch_map[nixos_arch] = {
                "url": binary["package"]["link"],
                "sha256": binary["package"]["checksum"],
                "version": version,
                "build": build,
            }

out = {}
for feature_version in feature_versions:
    # Default user-agent is blocked by Azure WAF.
    headers = {'user-agent': 'nixpkgs-temurin-generate-sources/1.0.0'}
    resp = requests.get(f"https://api.adoptium.net/v3/assets/latest/{feature_version}/hotspot", headers=headers)

    if resp.status_code != 200:
        print("error: could not fetch data for release {} (code {}) {}".format(feature_version, resp.status_code, resp.content), file=sys.stderr)
        sys.exit(1)
    generate_sources(resp.json(), f"openjdk{feature_version}", out)

# these are not found in the API yet
for feature_version in ea_feature_versions:
    github_headers = {}
    if GITHUB_TOKEN:
        github_headers['Authorization'] = f"token {GITHUB_TOKEN}"
    resp = requests.get(f"https://api.github.com/repos/adoptium/temurin{feature_version}-binaries/releases", headers = github_headers)
    if resp.status_code != 200:
        print("error: could not fetch data for release {} (code {}) {}".format(feature_version, resp.status_code, resp.content), file=sys.stderr)
        sys.exit(1)

    asset_descriptions = []
    newest = sorted(resp.json(), key=lambda x: x['published_at'], reverse=True)[0]
    for asset in newest['assets']:
        name = asset['name']
        if (name.startswith('OpenJDK-jre_') or name.startswith('OpenJDK-jdk_')) and name.endswith('json'):
            # This allows the Temurin admins to steal your GitHub token...
            # but you didn't give this script access to a privileged token
            # anyway, right?
            resp = requests.get(asset['browser_download_url'], headers = github_headers)
            if resp.status_code != 200:
                print("error: could not fetch data for release {} asset {} (code {}) {}".format(feature_version, asset['name'], resp.status_code, resp.content), file=sys.stderr)
                sys.exit(1)
            a = resp.json()
            asset_descriptions.append({
                "binary": {
                    "os": a["os"],
                    "image_type": name[8:11],
                    "jvm_impl": "hotspot",
                    "heap_size": "normal",
                    "architecture": a["arch"],
                    "package": {
                        "link": asset['browser_download_url'][:-5],
                        "checksum": a["sha256"]
                    },
                },
                "version": a["version"],
            })

    generate_sources(asset_descriptions, f"openjdk{feature_version}", out)

with open("sources.json", "w") as f:
    json.dump(out, f, indent=2, sort_keys=True)
    f.write('\n')
