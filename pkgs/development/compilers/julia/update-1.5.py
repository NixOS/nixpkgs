#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 python3Packages.requests

import os
import re
import requests
import subprocess

latest = requests.get("https://api.github.com/repos/JuliaLang/julia/releases/latest").json()["tag_name"]
assert latest[0] == "v"
major, minor, patch = latest[1:].split(".")
assert major == "1"
# When a new minor version comes out we'll have to refactor/copy this update script.
assert minor == "5"

sha256 = subprocess.check_output(["nix-prefetch-url", "--unpack", f"https://github.com/JuliaLang/julia/releases/download/v{major}.{minor}.{patch}/julia-{major}.{minor}.{patch}-full.tar.gz"], text=True).strip()

nix_path = os.path.join(os.path.dirname(__file__), "1.5.nix")
nix0 = open(nix_path, "r").read()
nix1 = re.sub("maintenanceVersion = \".*\";", f"maintenanceVersion = \"{patch}\";", nix0)
nix2 = re.sub("src_sha256 = \".*\";", f"src_sha256 = \"{sha256}\";", nix1)
open(nix_path, "w").write(nix2)
