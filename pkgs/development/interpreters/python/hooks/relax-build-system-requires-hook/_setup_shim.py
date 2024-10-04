""" """

from __future__ import annotations

import os
from logging import getLogger

import setuptools
from setuptools import setup as _orig

import relax_build_system_requires_utils


logger = getLogger(__name__)

SETUP_REQUIRES = "setup_requires"
TESTS_REQUIRE = "tests_require"


def setup_shim(*args, **kwargs):
    raw_setup_requires: str | list[str] = kwargs.get(SETUP_REQUIRES, "")
    if isinstance(raw_setup_requires, list):
        setup_requires = raw_setup_requires
    else:
        setup_requires = list(filter(lambda x: x != "", raw_setup_requires.split("\n")))

    relax_packages = relax_build_system_requires_utils.get_relax_packages(
        "relaxBuildSystem"
    )
    logger.info(f"relaxing {relax_packages} from setup_requires")

    remove_packages = relax_build_system_requires_utils.get_relax_packages(
        "removeBuildSystem"
    )
    logger.info(f"removing {remove_packages} from setup_requires")

    relaxed_setup_requires = relax_build_system_requires_utils.relax_requires(
        setup_requires, relax_packages, remove_packages
    )

    kwargs[SETUP_REQUIRES] = relaxed_setup_requires

    if os.getenv("removeTestsRequire"):
        if kwargs.get(TESTS_REQUIRE):
            del kwargs[TESTS_REQUIRE]
        else:
            logger.warning(f"No {TESTS_REQUIRE} found in setup.py")

    _orig(*args, **kwargs)


setuptools.setup = setup_shim
