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
from configparser import ConfigParser
from logging import getLogger
from pathlib import Path

from tomlkit import TOMLDocument, parse, dumps
from tomlkit.items import Array

import relax_build_system_requires_utils


logger = getLogger(__name__)


def load_pyproject_toml(path: Path) -> TOMLDocument:
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


def relax_pyproject_toml(path: Path, relax_packages, remove_packages) -> None:
    pyproject = load_pyproject_toml(path)

    build_system_requires = get_build_system_requires(pyproject)
    if build_system_requires is None:
        logger.warning("No build-system.requires found in pyproject.toml")
        return
    relaxed_requires = relax_build_system_requires_utils.relax_requires(
        build_system_requires, relax_packages, remove_packages
    )

    relaxed_pyproject = set_build_system_requires(pyproject, relaxed_requires)

    dump_pyproject_toml(path, relaxed_pyproject)


def load_setup_cfg(path: Path) -> ConfigParser:
    cfg = ConfigParser()
    cfg.read(path)
    return cfg


def dump_setup_cfg(path: Path, cfg: ConfigParser) -> None:
    with path.open("w") as f:
        cfg.write(f)


def get_setup_requires(cfg: ConfigParser) -> list[str] | None:
    try:
        raw_setup_requires = cfg["options"]["setup_requires"]
        return list(filter(lambda x: x != "", raw_setup_requires.split("\n")))
    except KeyError:
        return None


def set_setup_requires(cfg: ConfigParser, requires: list[str]) -> ConfigParser:
    cfg["options"]["setup_requires"] = "\n".join([""] + requires)
    return cfg


def relax_setup_cfg(path: Path, relax_packages, remove_packages) -> None:
    setup_cfg = load_setup_cfg(path)

    setup_requires = get_setup_requires(setup_cfg)
    if setup_requires is None:
        logger.warning("No options.setup_requires found in setup.cfg")
        return
    relaxed_requires = relax_build_system_requires_utils.relax_requires(
        setup_requires, relax_packages, remove_packages
    )

    relaxed_setup_cfg = set_setup_requires(setup_cfg, relaxed_requires)

    if os.getenv("removeTestsRequire"):
        try:
            del relaxed_setup_cfg["options"]["tests_require"]
        except KeyError:
            logger.exception("No options.tests_require found in setup.cfg")

    dump_setup_cfg(path, relaxed_setup_cfg)


def patch_setuppy(path: Path) -> None:
    """

    Args:
        path:
    """
    with path.open("r") as f:
        setuppy = f.readlines()

    setuppy.insert(0, "import _setup_shim\n")
    with path.open("w") as f:
        f.writelines(setuppy)


if __name__ == "__main__":
    pyproject_path = Path("./pyproject.toml")
    setup_py_path = Path("./setup.py")
    setup_cfg_path = Path("./setup.cfg")

    if setup_py_path.exists():
        patch_setuppy(setup_py_path)

        if (not pyproject_path.exists()) and (not setup_cfg_path.exists()):
            sys.exit(0)

    relax_packages = relax_build_system_requires_utils.get_relax_packages(
        "relaxBuildSystem"
    )
    remove_packages = relax_build_system_requires_utils.get_relax_packages(
        "removeBuildSystem"
    )

    if pyproject_path.exists():
        relax_pyproject_toml(pyproject_path, relax_packages, remove_packages)

    if setup_cfg_path.exists():
        relax_setup_cfg(setup_cfg_path, relax_packages, remove_packages)
