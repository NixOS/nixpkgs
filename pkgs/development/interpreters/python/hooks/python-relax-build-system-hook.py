"""Helper to relax or remove build-system requirements in pyproject.toml."""

import sys
from packaging.requirements import Requirement
from packaging.utils import canonicalize_name
from tomlkit import dump, load


relax_all = False
relax_packages: set[str] = set()
remove_packages: set[str] = set()

input = 1
while input < len(sys.argv):
    arg = sys.argv[input]
    if arg == "--relax-all":
        relax_all = True
    elif arg == "--relax" and input + 1 < len(sys.argv):
        relax_packages.add(canonicalize_name(sys.argv[input + 1]))
        input += 1
    elif arg == "--remove" and input + 1 < len(sys.argv):
        remove_packages.add(canonicalize_name(sys.argv[input + 1]))
        input += 1
    input += 1

try:
    with open("pyproject.toml") as file_toml:
        pyproject = load(file_toml)
except FileNotFoundError:
    print("pythonRelaxBuildSystemHook: pyproject.toml not found, skipping")
    sys.exit(0)

if "requires" not in pyproject.get("build-system", {}):
    print(
        "pythonRelaxBuildSystemHook: no [build-system].requires in pyproject.toml, skipping"
    )
    sys.exit(0)

new_requires = []

for requires_str in pyproject["build-system"]["requires"]:
    requires = Requirement(requires_str)
    normalized = canonicalize_name(requires.name)

    if normalized in remove_packages:
        print(
            f"pythonRelaxBuildSystemHook: removing build requirement: {requires_str!r}"
        )
    elif relax_all or normalized in relax_packages:
        extras = f"[{','.join(sorted(requires.extras))}]" if requires.extras else ""
        marker = f" ; {requires.marker}" if requires.marker else ""
        new_req = f"{requires.name}{extras}{marker}"
        if requires.specifier:
            print(
                f"pythonRelaxBuildSystemHook: relaxing build requirement: {requires_str!r} -> {new_req!r}"
            )
        new_requires.append(new_req)
    else:
        new_requires.append(requires_str)

pyproject["build-system"]["requires"] = new_requires

with open("pyproject.toml", "w") as file_toml:
    dump(pyproject, file_toml)
