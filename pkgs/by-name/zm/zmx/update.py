#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 python3Packages.packaging common-updater-scripts nix nixfmt-rfc-style

import shutil
import subprocess
import tempfile
import urllib.request
from pathlib import Path

from packaging.version import InvalidVersion, Version

PACKAGE = "zmx"
REPO_URL = "https://github.com/neurosnap/zmx"
# nixpkgs' zon2nix currently fails to parse zmx's Zig 0.15 build.zig.zon.
# Keep using the generator that produced the existing dependency file.
ZON2NIX = "github:Cloudef/zig2nix#zon2nix"


def run(*args: str, cwd: Path | None = None) -> None:
    subprocess.run(args, cwd=cwd, check=True)


def output(*args: str) -> str:
    return subprocess.check_output(args, text=True).strip()


def latest_version() -> str:
    tags = output("list-git-tags", f"--url={REPO_URL}").splitlines()
    versions: list[tuple[Version, str]] = []

    for tag in tags:
        version = tag.removeprefix("v")
        try:
            versions.append((Version(version), version))
        except InvalidVersion:
            pass

    if not versions:
        raise RuntimeError(f"No valid version tags found for {REPO_URL}")

    return max(versions, key=lambda item: item[0])[1]


def patch_zon2nix_output(path: Path) -> None:
    patched_lines: list[str] = []

    for line in path.read_text().splitlines(keepends=True):
        if line.lstrip().startswith("name = "):
            line = line.replace('.tar.gz";', '";')

        line = line.replace("$TMPDIR/p/$hash.tar.gz", "$TMPDIR/p/$hash")
        line = line.replace('outputHashMode = "flat";', 'outputHashMode = "recursive";')
        patched_lines.append(line)

    path.write_text("".join(patched_lines))


def main() -> None:
    package_dir = Path(__file__).resolve().parent
    version = latest_version()

    run("update-source-version", PACKAGE, version)

    with tempfile.TemporaryDirectory() as tmp:
        tmpdir = Path(tmp)
        zon = tmpdir / "build.zig.zon"
        urllib.request.urlretrieve(f"{REPO_URL}/raw/v{version}/build.zig.zon", zon)

        run(
            "nix",
            "--extra-experimental-features",
            "nix-command flakes",
            "run",
            ZON2NIX,
            "--",
            "build.zig.zon",
            cwd=tmpdir,
        )

        generated = tmpdir / "build.zig.zon.nix"
        target = package_dir / "build.zig.zon.nix"
        shutil.move(generated, target)

    patch_zon2nix_output(target)
    run("nixfmt", target.as_posix())


if __name__ == "__main__":
    main()
