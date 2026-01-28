#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p 'python3.withPackages(ps: [ps.requests ps.plumbum])' nix-prefetch
import json
import requests
from pathlib import Path
from plumbum.cmd import nix_prefetch

HERE = Path(__file__).parent


def write_release(releases):
    with HERE.joinpath("releases.json").open("w") as fd:
        json.dump(releases, fd, indent=2)
        fd.write("\n")


wheels = {}

python_versions = ["314", "313", "312", "311", "310"]
systems = [
    "x86_64-linux",
    "aarch64-linux",
    "x86_64-darwin",
    "aarch64-darwin",
]


def system_to_platform(python_version, system):
    match system:
        case "x86_64-linux":
            return "manylinux_2_24_x86_64"
        case "aarch64-linux":
            return "manylinux_2_24_aarch64"
        case "x86_64-darwin":
            return (
                "macosx_11_0_x86_64"
                if python_version == "314"
                else "macosx_10_11_x86_64"
            )
        case "aarch64-darwin":
            return "macosx_11_0_arm64"


for python_version in python_versions:
    for system in systems:
        platform = system_to_platform(python_version, system)
        wheels[f"{python_version}-{system}"] = {
            "platform": platform,
        }


resp = requests.get("https://pypi.org/pypi/saxonche/json")
assert resp.status_code == 200
resp = resp.json()
version = resp["info"]["version"]
wheels["version"] = version


for system in systems:
    for python_version in python_versions:
        cp_version = f"cp{python_version}"
        platform = system_to_platform(python_version, system)
        print(f"downloading {python_version}-{system}: ", end="", flush=True)
        hash = nix_prefetch.with_cwd(HERE)[
            "fetchPypi",
            "--version",
            version,
            "--pname",
            "saxonche",
            "--format",
            "wheel",
            "--python",
            cp_version,
            "--abi",
            cp_version,
            "--dist",
            cp_version,
            "--platform",
            platform,
            "--quiet",
        ]().strip()
        print(f"{hash}")
        wheels[f"{python_version}-{system}"]["hash"] = hash

write_release(wheels)
