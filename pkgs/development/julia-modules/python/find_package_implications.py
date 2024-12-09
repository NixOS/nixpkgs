
import json
import os
from pathlib import Path
import subprocess
import sys
import yaml

dependencies_path = Path(sys.argv[1])
package_implications_json = sys.argv[2]
out_path = Path(sys.argv[3])

package_implications = json.loads(package_implications_json)
with open(dependencies_path) as f:
  desired_packages = yaml.safe_load(f) or []

extra_package_names = []
for pkg in desired_packages:
  if pkg["name"] in package_implications:
    extra_package_names.extend(package_implications[pkg["name"]])

if len(extra_package_names) > 0:
  with open(out_path, "w") as f:
    f.write("\n".join(extra_package_names))
