from os import environ
from packaging.requirements import Requirement
from packaging.specifiers import SpecifierSet
from pathlib import Path
import json, tomlkit


# JSON input is expected, so the derivation must set __structuredAttrs
nixAttrs = json.load(Path(environ['NIX_ATTRS_JSON_FILE']).open())
removeDeps = frozenset(nixAttrs.get("pythonRemoveBuildDeps", []))

match nixAttrs.get("pythonRelaxBuildDeps", []):
    case [ *requirements ]:
        relaxDeps = { req.name: req for req in map(Requirement, requirements) }
    case _:
        # No support (yet?) for `pythonRelaxBuildDeps.foo = ">1, <2";`; see
        #  https://github.com/NixOS/nixpkgs/pull/382125#discussion_r1956658253
        raise ValueError(f"Expected a list for `pythonRelaxBuildDeps`, was '{type(relaxDeps)}'")

# Quick input validation
match removeDeps.intersection(relaxDeps):
    case []: pass
    case [ *overlap ]:
        raise ValueError(
            "The following dependencies occur in both 'pythonRelaxBuildDeps` and 'pythonRemoveBuildDeps`: " + \
            ", ".join(overlappingDeps)
        )

# Parse pyproject.toml, update as needed, and write back out
pyPrjPath = Path("pyproject.toml")
pyProject = tomlkit.load(pyPrjPath.open())

pyProject['build-system']['requires'] = [
    str(relaxDeps[req.name]) if req.name in relaxDeps else orig
    for req, orig in ((Requirement(orig), orig) for orig in pyProject['build-system']['requires'])
    if req.name not in removeDeps
]

tomlkit.dump(pyProject, pyPrjPath.open("w"))
