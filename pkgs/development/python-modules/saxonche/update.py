#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p 'python3.withPackages(ps: [ps.requests ps.packaging])'
import json
import requests
from pathlib import Path
from packaging.utils import parse_wheel_filename
import base64

HERE = Path(__file__).parent


def write_release(releases):
    with HERE.joinpath("releases.json").open("w") as fd:
        json.dump(releases, fd, indent=2)
        fd.write("\n")


wheels = {}

resp = requests.get("https://pypi.org/pypi/saxonche/json")
assert resp.status_code == 200
resp = resp.json()
version = resp["info"]["version"]
wheels["version"] = version

for file in resp["urls"]:
    python_version: str = file["python_version"]  # for example "cp310"
    _, _, _, tags = parse_wheel_filename(file["filename"])
    (tag,) = tags  # There should only be one tag, take it from the frozenset
    platform = tag.platform

    if "x86_64" in platform:
        isa = "x86_64"
    elif "arm64" in platform or "aarch64" in platform:
        isa = "aarch64"
    else:
        continue

    if "macosx" in platform:
        os = "darwin"
    elif "manylinux" in platform:
        os = "linux"
    else:
        continue

    hex_hash: str = file["digests"]["sha256"]
    sri_hash = f"sha256-{base64.b64encode(bytes.fromhex(hex_hash)).decode('utf-8')}"

    wheels[f"{python_version}-{isa}-{os}"] = {
        "platform": platform,
        "hash": sri_hash,
    }

write_release(wheels)
