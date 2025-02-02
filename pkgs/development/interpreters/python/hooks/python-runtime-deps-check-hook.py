#!/usr/bin/env python3
"""
The runtimeDependenciesHook validates, that all dependencies specified
in wheel metadata are available in the local environment.

In case that does not hold, it will print missing dependencies and
violated version constraints.
"""


import importlib.metadata
import re
import sys
import tempfile
from argparse import ArgumentParser
from zipfile import ZipFile

from packaging.metadata import Metadata, parse_email
from packaging.requirements import Requirement

argparser = ArgumentParser()
argparser.add_argument("wheel", help="Path to the .whl file to test")


def error(msg: str) -> None:
    print(f"  - {msg}", file=sys.stderr)


def normalize_name(name: str) -> str:
    """
    Normalize package names according to PEP503
    """
    return re.sub(r"[-_.]+", "-", name).lower()


def get_manifest_text_from_wheel(wheel: str) -> str:
    """
    Given a path to a wheel, this function will try to extract the
    METADATA file in the wheels .dist-info directory.
    """
    with ZipFile(wheel) as zipfile:
        for zipinfo in zipfile.infolist():
            if zipinfo.filename.endswith(".dist-info/METADATA"):
                with tempfile.TemporaryDirectory() as tmp:
                    path = zipfile.extract(zipinfo, path=tmp)
                    with open(path, encoding="utf-8") as fd:
                        return fd.read()

    raise RuntimeError("No METADATA file found in wheel")


def get_metadata(wheel: str) -> Metadata:
    """
    Given a path to a wheel, returns a parsed Metadata object.
    """
    text = get_manifest_text_from_wheel(wheel)
    raw, _ = parse_email(text)
    metadata = Metadata.from_raw(raw)

    return metadata


def test_requirement(requirement: Requirement) -> bool:
    """
    Given a requirement specification, tests whether the dependency can
    be resolved in the local environment, and whether it satisfies the
    specified version constraints.
    """
    if requirement.marker and not requirement.marker.evaluate():
        # ignore requirements with incompatible markers
        return True

    package_name = normalize_name(requirement.name)

    try:
        package = importlib.metadata.distribution(requirement.name)
    except importlib.metadata.PackageNotFoundError:
        error(f"{package_name} not installed")
        return False

    if requirement.specifier and package.version not in requirement.specifier:
        error(
            f"{package_name}{requirement.specifier} not satisfied by version {package.version}"
        )
        return False

    return True


if __name__ == "__main__":
    args = argparser.parse_args()

    metadata = get_metadata(args.wheel)
    requirements = metadata.requires_dist

    if not requirements:
        sys.exit(0)

    tests = [test_requirement(requirement) for requirement in requirements]

    if not all(tests):
        sys.exit(1)
