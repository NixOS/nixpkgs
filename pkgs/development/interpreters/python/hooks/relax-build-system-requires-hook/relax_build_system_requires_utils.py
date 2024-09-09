from __future__ import annotations

import os
from collections.abc import Iterable
from typing import Literal

from packaging.requirements import Requirement


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
    build_system_requires: Iterable[str],
    relax_packages: Iterable[str] = [],
    remove_packages: Iterable[str] = [],
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
