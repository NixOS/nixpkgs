#!/usr/bin/env python3
"""
The relaxBuildSystemRequiresHook remove the `build-system.requires`
version constraint.

If there is no pyproject.toml or no build-system.requires table,
do nothing.
"""

from __future__ import annotations

import os
import sys
from logging import getLogger
from pathlib import Path
from typing import Literal

from packaging.requirements import Requirement
from tomlkit import TOMLDocument, parse, dumps
from tomlkit.items import Array

logger = getLogger(__name__)


def parse_pyproject_toml(path: Path) -> TOMLDocument:
    with path.open("r") as f:
        pyproject = parse(f.read())
    return pyproject


def dump_pyproject_toml(path: Path, pyproject: TOMLDocument) -> None:
    with path.open("w") as f:
        f.write(dumps(pyproject))


def get_build_system_requires(pyproject: TOMLDocument) -> Array | None:
    return pyproject.get("build-system", {}).get("requires")


def set_build_system_requires(
    pyproject: TOMLDocument, requires: list[str]
) -> TOMLDocument:
    pyproject["build-system"]["requires"] = requires
    return pyproject


def get_relax_packages(
    env_var: Literal["relaxBuildSystem", "removeBuildSystem"],
) -> list[str]:
    """Get the list of packages to relax constraints from the environment variable.

    Args:
        env_var: The name of the environment variable to be processed.

    Returns:
        A list of package names that relax constraints.
    """
    relax_packages = os.getenv(env_var)
    return relax_packages.split() if (relax_packages is not None) else []


def relax_requires(
    build_system_requires: Array,
    relax_packages: list[str] = [],
    remove_packages: list[str] = [],
) -> list[str]:
    """Relax constraints for given packages.

    Args:
        build_system_requires: Requirements before relaxing constraints.
        relax_packages: List of packages whose constraints should be relaxed.
        remove_packages: List of packages that should be removed.

    Returns:
        A list of requirements with the specified packages relaxed or removed.
    """
    return [
        relaxed_package if relaxed_package in relax_packages else package
        for package in build_system_requires
        if (relaxed_package := Requirement(package).name) not in remove_packages
    ]


if __name__ == "__main__":
    pyproject_path = Path("./pyproject.toml")
    if not pyproject_path.exists():
        logger.warning("No pyproject.toml found")
        sys.exit(0)

    pyproject = parse_pyproject_toml(pyproject_path)

    build_system_requires = get_build_system_requires(pyproject)
    if build_system_requires is None:
        logger.warning("No build-system.requires found in pyproject.toml")
        sys.exit(0)

    relax_packages = get_relax_packages("relaxBuildSystem")
    remove_packages = get_relax_packages("removeBuildSystem")

    relaxed_requires = relax_requires(
        build_system_requires, relax_packages, remove_packages
    )

    relaxed_pyproject = set_build_system_requires(pyproject, relaxed_requires)

    dump_pyproject_toml(pyproject_path, relaxed_pyproject)
