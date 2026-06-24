#!/usr/bin/env python3
"""
Generate PEP 643 metadata from PEP 621 pyproject.toml

ref. https://packaging.python.org/en/latest/specifications/recording-installed-packages/
"""

from argparse import ArgumentParser
from pathlib import Path
from tomllib import load

from pyproject_metadata import StandardMetadata


parser = ArgumentParser()
parser.add_argument("pyproject", type=Path, help="Path to source pyproject.toml")
parser.add_argument("site_packages", type=Path, help="Path to $out/$pythonSitePackages")


def generate_metadata(pyproject: Path, site_packages: Path):
    with pyproject.open("rb") as f:
        metadata = StandardMetadata.from_pyproject(load(f))

    dist = f"{metadata.name.replace('-', '_')}-{metadata.version}"
    dist_info = site_packages / f"{dist}.dist-info"
    dist_info.mkdir(parents=True)

    with (dist_info / "METADATA").open("w") as f:
        print(metadata.as_rfc822(), file=f)


if __name__ == "__main__":
    args = parser.parse_args()
    generate_metadata(args.pyproject, args.site_packages)
