# Patch pyproject.toml to use setuptools in legacy mode as a PEP-517 builder.
#
# https://pip.pypa.io/en/stable/reference/build-system/pyproject-toml/#fallback-behaviour

import sys; sys.path.append("@tomlkit@")
import tomlkit


BUILD_BACKEND = "setuptools.build_meta:__legacy__"


if __name__ == "__main__":
    # If package has no pyproject.toml fallback behaviour is already in effect.
    try:
        with open("pyproject.toml") as fd:
            pyproject = tomlkit.load(fd)
    except FileNotFoundError:
        exit(0)

    # If package has no build-system legacy fallback behaviour is already in effect.
    try:
        build_system = pyproject["build-system"]
    except KeyError:
        exit(0)

    # Some packages (like skia-pathops) defines build-system.requires but not build-system.build-backend.
    # This signifies that it's building using the setuptools legacy builder, but with additional requirements like cython.
    # Skia-pathops in particular parses pyproject.toml at build time to check it's minimum cython version, meaning that
    # it's unsafe simply always apply this patching, so we only do so when strictly necessary.
    try:
        if build_system["build-backend"] == BUILD_BACKEND:
            exit(0)
    except KeyError:
        exit(0)

    build_system["requires"] = ["setuptools>=40.8.0", "wheel"]
    build_system["build-backend"] = BUILD_BACKEND

    with open("pyproject.toml", "w") as fd:
        tomlkit.dump(pyproject, fd)
