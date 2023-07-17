#!/usr/bin/env python3

import json
from pathlib import Path
import toml
import sys

vendor_dir = Path(sys.argv[1])
package_names = json.loads(sys.argv[2])
cargo_lock_path = Path(sys.argv[3])
out = Path(sys.argv[4])


name_to_dir = {}
for subdir in (f for f in vendor_dir.resolve().glob('**/*') if f.is_dir()):
  cargo_toml_path = subdir / "Cargo.toml"
  if not cargo_toml_path.exists(): continue

  cargo_toml = toml.load(cargo_toml_path)

  if "package" in cargo_toml:
    if "name" in cargo_toml["package"]:
      name_to_dir[cargo_toml["package"]["name"]] = subdir

with open(out, "a") as f:
  for package in package_names:
    if package in name_to_dir:
      f.write(f""":dep {package} = {{ path = "{str(name_to_dir[package])}" }}\n""")
