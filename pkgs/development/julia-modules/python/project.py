
from collections import defaultdict
import json
import os
from pathlib import Path
import sys
import toml
import yaml


desired_packages_path = Path(sys.argv[1])
stdlib_infos_path = Path(sys.argv[2])
package_overrides = json.loads(sys.argv[3])
dependencies_path = Path(sys.argv[4])
out_path = Path(sys.argv[5])

with open(desired_packages_path, "r") as f:
  desired_packages = yaml.safe_load(f) or []

with open(stdlib_infos_path, "r") as f:
  stdlib_infos = yaml.safe_load(f) or []

with open(dependencies_path, "r") as f:
  uuid_to_store_path = yaml.safe_load(f)

result = {
  "deps": defaultdict(list)
}

for pkg in desired_packages:
  if pkg["uuid"] in package_overrides:
    info = package_overrides[pkg["uuid"]]
    result["deps"][info["name"]].append({
      "uuid": pkg["uuid"],
      "path": info["src"],
    })
    continue

  path = uuid_to_store_path.get(pkg["uuid"], None)
  isStdLib = False
  if pkg["uuid"] in stdlib_infos["stdlibs"]:
    path = stdlib_infos["stdlib_root"] + "/" + stdlib_infos["stdlibs"][pkg["uuid"]]["name"]
    isStdLib = True

  if path:
    if (Path(path) / "Project.toml").exists():
      project_toml = toml.load(Path(path) / "Project.toml")

      deps = []
      weak_deps = project_toml.get("weakdeps", {})
      extensions = project_toml.get("extensions", {})

      if "deps" in project_toml:
        # Build up deps for the manifest, excluding weak deps
        weak_deps_uuids = weak_deps.values()
        for (dep_name, dep_uuid) in project_toml["deps"].items():
          if not (dep_uuid in weak_deps_uuids):
            deps.append(dep_name)
    else:
      # Not all projects have a Project.toml. In this case, use the deps we
      # calculated from the package resolve step. This isn't perfect since it
      # will fail to properly split out weak deps, but it's better than nothing.
      print(f"""WARNING: package {pkg["name"]} didn't have a Project.toml in {path}""")
      deps = [x["name"] for x in pkg.get("deps", [])]
      weak_deps = {}
      extensions = {}

    tree_hash = pkg.get("tree_hash", "")

    result["deps"][pkg["name"]].append({
      "version": pkg["version"],
      "uuid": pkg["uuid"],
      "git-tree-sha1": (tree_hash if tree_hash != "nothing" else None) or None,
      "deps": deps or None,
      "weakdeps": weak_deps or None,
      "extensions": extensions or None,

      # We *don't* set "path" here, because then Julia will try to use the
      # read-only Nix store path instead of cloning to the depot. This will
      # cause packages like Conda.jl to fail during the Pkg.build() step.
      #
      # "path": None if isStdLib else path ,
    })
  else:
    print("WARNING: adding a package that we didn't have a path for, and it doesn't seem to be a stdlib", pkg)
    result["deps"][pkg["name"]].append({
      "version": pkg["version"],
      "uuid": pkg["uuid"],
      "deps": [x["name"] for x in pkg["deps"]]
    })

os.makedirs(out_path)

with open(out_path / "Manifest.toml", "w") as f:
  f.write(f'julia_version = "{stdlib_infos["julia_version"]}"\n')
  f.write('manifest_format = "2.0"\n\n')
  toml.dump(result, f)

with open(out_path / "Project.toml", "w") as f:
  f.write('[deps]\n')

  for pkg in desired_packages:
    if pkg.get("is_input", False):
      f.write(f'''{pkg["name"]} = "{pkg["uuid"]}"\n''')
