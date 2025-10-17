
import json
from pathlib import Path
import re
import shutil
import sys
import toml
import util
import yaml


registry_path = Path(sys.argv[1])
package_overrides = json.loads(sys.argv[2])
desired_packages_path = Path(sys.argv[3])
out_path = Path(sys.argv[4])

with open(desired_packages_path, "r") as f:
  desired_packages = yaml.safe_load(f) or []

registry = toml.load(registry_path / "Registry.toml")

def ensure_version_valid(version):
  """
  Ensure a version string is a valid Julia-parsable version.
  It doesn't really matter what it looks like as it's just used for overrides.
  """
  return re.sub('[^0-9.]','', version)

with open(out_path, "w") as f:
  f.write("{fetchgit}:\n")
  f.write("{\n")
  for pkg in desired_packages:
    uuid = pkg["uuid"]

    if pkg["name"] in package_overrides:
      treehash = util.get_commit_info(package_overrides[pkg["name"]])["tree"]
      f.write(f"""  "{uuid}" = {{
    src = null; # Overridden: will fill in later
    name = "{pkg["name"]}";
    version = "{ensure_version_valid(pkg["version"])}";
    treehash = "{treehash}";
  }};\n""")
    elif uuid in registry["packages"]:
      # The treehash is missing for stdlib packages. Don't bother downloading these.
      if (not ("tree_hash" in pkg)) or pkg["tree_hash"] == "nothing": continue

      registry_info = registry["packages"][uuid]
      path = registry_info["path"]
      packageToml = toml.load(registry_path / path / "Package.toml")

      versions_toml = registry_path / path / "Versions.toml"
      all_versions = toml.load(versions_toml)
      if not pkg["version"] in all_versions: continue
      version_to_use = all_versions[pkg["version"]]

      if not "nix-sha256" in version_to_use:
        raise KeyError(f"""Couldn't find nix-sha256 hash for {pkg["name"]} {pkg["version"]} in {versions_toml}. This might indicate that we failed to prefetch the hash when computing the augmented registry. Was there a relevant failure in {registry_path / "failures.yml"}?""")

      repo = packageToml["repo"]
      f.write(f"""  "{uuid}" = {{
    src = fetchgit {{
      url = "{repo}";
      rev = "{version_to_use["git-tree-sha1"]}";
      sha256 = "{version_to_use["nix-sha256"]}";
    }};
    name = "{pkg["name"]}";
    version = "{pkg["version"]}";
    treehash = "{version_to_use["git-tree-sha1"]}";
  }};\n""")
    else:
      # This is probably a stdlib
      # print("WARNING: couldn't figure out what to do with pkg in sources_nix.py", pkg)
      pass

  f.write("}")
