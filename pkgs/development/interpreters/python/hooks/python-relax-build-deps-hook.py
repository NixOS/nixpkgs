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
    def requirementWithSpec(name, spec):
        """Construct a Requirement with a given name and version specifier"""
        r = Requirement(name)
        r.specifier = SpecifierSet(spec)
        return r

    relaxDeps = {
        name: requirementWithSpec(name, spec)
        for name, spec in relexDeps.items()
    }

overlappingDeps = removeDeps.intersection(relaxDeps)
if overlappingDeps:
    raise ValueError(
        "The following dependencies occur in both 'pythonRelaxBuildDeps` and 'pythonRemoveBuildDeps`: " + \
        ", ".join(overlappingDeps)
    )

pyPrjPath = Path("pyproject.toml")
pyProject = tomlkit.load(pyPrjPath.open())

buildRequires = tomlkit.array()
# buildRequires.trivia = pyProject['build-system']['requires'].trivia
for orig in pyProject['build-system']['requires']:
    req = Requirement(orig)  # Parse the PEP 508 dependency specifier
    if req.name in removeDeps:
        print(f"Removing '{req}'")
    elif req.name in relaxDeps:
        nreq = relaxDeps[req.name]
        print(f"Rewriting '{req}' with version(s) '{nreq.specifier}'")
        buildRequires.append(str(nreq))
    else:
        #print(f"Keeping '{orig}'")
        buildRequires.append(orig)

pyProject['build-system']['requires'] = buildRequires
tomlkit.dump(pyProject, pyPrjPath.open("w"))
