from os import environ
from packaging.requirements import Requirement
from packaging.specifiers import SpecifierSet
from pathlib import Path
import json, tomlkit


nixAttrs = json.load(Path(environ['NIX_ATTRS_JSON_FILE']).open())
removeDeps = frozenset(nixAttrs.get("pythonRemoveBuildDeps", []))

relaxDeps = nixAttrs.get("pythonRelaxBuildDeps", {})
if isinstance(relaxDeps, list):
    relaxDeps = { req.name: req for req in map(Requirement, relaxDeps) }
else:
    # No support (yet?) for `pythonRelaxBuildDeps.foo = ">1, <2";`; see
    #  https://github.com/NixOS/nixpkgs/pull/382125#discussion_r1956658253
    raise ValueError(f"Expected a list for `pythonRelaxBuildDeps`, was '{type(relaxDeps)}'")

overlappingDeps = removeDeps.intersection(relaxDeps)
if overlappingDeps:
    raise ValueError(
        "The following dependencies occur in both 'pythonRelaxBuildDeps` and 'pythonRemoveBuildDeps`: " + \
        ", ".join(overlappingDeps)
    )

pyPrjPath = Path("pyproject.toml")
pyProject = tomlkit.load(pyPrjPath.open())

pyProject['build-system']['requires'] = [
    str(relaxDeps[req.name]) if req.name in relaxDeps else orig
    for req, orig in ((Requirement(orig), orig) for orig in pyProject['build-system']['requires'])
    if req.name not in removeDeps
]

tomlkit.dump(pyProject, pyPrjPath.open("w"))
