import json
import os
import requests
import shutil
import subprocess
import sys
import tempfile

# See YC_SDK_STORAGE_URL in
# https://storage.yandexcloud.net/yandexcloud-yc/install.sh
storage_url = "https://storage.yandexcloud.net/yandexcloud-yc"

systems = [
    ("aarch64", "darwin"),
    ("aarch64", "linux"),
    ("i686", "linux"),
    ("x86_64", "darwin"),
    ("x86_64", "linux"),
]


def to_goarch(cpu):
    return {
        "aarch64": "arm64",
        "i686": "386",
        "x86_64": "amd64",
    }.get(cpu, cpu)


nixpkgs_path = "."
attr_path = os.getenv("UPDATE_NIX_ATTR_PATH", "yandex-cloud")

package_attrs = json.loads(subprocess.run(
    [
        "nix",
        "--extra-experimental-features", "nix-command",
        "eval",
        "--json",
        "--file", nixpkgs_path,
        "--apply", """p: {
          dir = builtins.dirOf p.meta.position;
          version = p.version;
        }""",
        "--",
        attr_path,
    ],
    stdout=subprocess.PIPE,
    text=True,
    check=True,
).stdout)

old_version = package_attrs["version"]
new_version = requests.get(f"{storage_url}/release/stable").text.rstrip()

if new_version == old_version:
    sys.exit()

binaries = {}
for cpu, kernel in systems:
    goos = kernel
    goarch = to_goarch(cpu)
    system = f"{cpu}-{kernel}"

    url = f"{storage_url}/release/{new_version}/{goos}/{goarch}/yc"

    nix_hash = subprocess.run(
        [
            "nix-prefetch-url",
            "--type", "sha256",
            url,
        ],
        stdout=subprocess.PIPE,
        text=True,
        check=True,
    ).stdout.rstrip()

    sri_hash = subprocess.run(
        [
            "nix",
            "--extra-experimental-features", "nix-command",
            "hash",
            "to-sri",
            "--type", "sha256",
            "--",
            nix_hash,
        ],
        stdout=subprocess.PIPE,
        text=True,
        check=True,
    ).stdout.rstrip()

    binaries[system] = {
        "url": url,
        "hash": sri_hash,
    }

package_dir = package_attrs["dir"]
file_path = os.path.join(package_dir, "sources.json")
file_content = json.dumps({
    "version": new_version,
    "binaries": binaries,
}, indent=2) + "\n"

with tempfile.NamedTemporaryFile(mode="w") as t:
    t.write(file_content)
    t.flush()
    shutil.copyfile(t.name, file_path)
