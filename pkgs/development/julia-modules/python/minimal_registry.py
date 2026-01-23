
from collections import defaultdict
import copy
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import toml
import util
import yaml


registry_path = Path(sys.argv[1])
desired_packages_path = Path(sys.argv[2])
package_overrides = json.loads(sys.argv[3])
dependencies_path = Path(sys.argv[4])
out_path = Path(sys.argv[5])

with open(desired_packages_path, "r") as f:
  desired_packages = yaml.safe_load(f) or []

uuid_to_versions = defaultdict(list)
for pkg in desired_packages:
  uuid_to_versions[pkg["uuid"]].append(pkg["version"])

with open(dependencies_path, "r") as f:
  uuid_to_store_path = yaml.safe_load(f)

os.makedirs(out_path)

full_registry = toml.load(registry_path / "Registry.toml")
registry = full_registry.copy()
registry["packages"] = {k: v for k, v in registry["packages"].items() if k in uuid_to_versions}

for (uuid, versions) in uuid_to_versions.items():
  if uuid in package_overrides:
    info = package_overrides[uuid]

    # Make a registry entry based on the info from the package override
    path = Path(info["name"][0].upper()) / Path(info["name"])
    registry["packages"][uuid] = {
      "name": info["name"],
      "path": str(path),
    }

    os.makedirs(out_path / path)

    # Read the Project.yaml from the src
    project = toml.load(Path(info["src"]) / "Project.toml")

    # Generate all the registry files
    with open(out_path / path / Path("Compat.toml"), "w") as f:
      f.write('["%s"]\n' % info["version"])
      # Write nothing in Compat.toml, because we've already resolved everything
    with open(out_path / path / Path("Deps.toml"), "w") as f:
      f.write('["%s"]\n' % info["version"])
      if "deps" in project:
        toml.dump(project["deps"], f)
    with open(out_path / path / Path("Versions.toml"), "w") as f:
      f.write('["%s"]\n' % info["version"])
      f.write('git-tree-sha1 = "%s"\n' % info["treehash"])
    with open(out_path / path / Path("Package.toml"), "w") as f:
      toml.dump({
        "name": info["name"],
        "uuid": uuid,
        "repo": "file://" + info["src"],
      }, f)

  elif uuid in registry["packages"]:
    registry_info = registry["packages"][uuid]
    name = registry_info["name"]
    path = registry_info["path"]

    os.makedirs(out_path / path)

    # Copy some files to the minimal repo unchanged
    for f in ["Compat.toml", "Deps.toml", "WeakCompat.toml", "WeakDeps.toml"]:
      if (registry_path / path / f).exists():
        shutil.copy2(registry_path / path / f, out_path / path)

    # Copy the Versions.toml file, trimming down to the versions we care about.
    # In the case where versions=None, this is a weak dep, and we keep all versions.
    all_versions = toml.load(registry_path / path / "Versions.toml")
    versions_to_keep = {k: v for k, v in all_versions.items() if k in versions} if versions != None else all_versions
    for k, v in versions_to_keep.items():
      del v["nix-sha256"]
    with open(out_path / path / "Versions.toml", "w") as f:
      toml.dump(versions_to_keep, f)

    if versions is None:
      # This is a weak dep; just grab the whole Package.toml
      shutil.copy2(registry_path / path / "Package.toml", out_path / path / "Package.toml")
    elif uuid in uuid_to_store_path:
      # Fill in the local store path for the repo
      package_toml = toml.load(registry_path / path / "Package.toml")
      package_toml["repo"] = "file://" + uuid_to_store_path[uuid]
      with open(out_path / path / "Package.toml", "w") as f:
        toml.dump(package_toml, f)

# Look for missing weak deps and include them. This can happen when our initial
# resolve step finds dependencies, but we fail to resolve them at the project.py
# stage. Usually this happens because the package that depends on them does so
# as a weak dep, but doesn't have a Package.toml in its repo making this clear.
for pkg in desired_packages:
  for dep in (pkg.get("deps", []) or []):
    uuid = dep["uuid"]
    if not uuid in uuid_to_versions:
      entry = full_registry["packages"].get(uuid)
      if not entry:
        print(f"""WARNING: found missing UUID but couldn't resolve it: {uuid}""")
        continue

      # Add this entry back to the minimal Registry.toml
      registry["packages"][uuid] = entry

      # Bring over the Package.toml
      path = Path(entry["path"])
      if (out_path / path / "Package.toml").exists():
        continue
      Path(out_path / path).mkdir(parents=True, exist_ok=True)
      shutil.copy2(registry_path / path / "Package.toml", out_path / path / "Package.toml")

# Finally, dump the Registry.toml
with open(out_path / "Registry.toml", "w") as f:
    toml.dump(registry, f)
