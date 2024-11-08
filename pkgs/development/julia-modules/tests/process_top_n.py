#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p "python3.withPackages(ps: with ps; [ pyyaml toml ])"

import csv
from pathlib import Path
import sys
import toml
import yaml

requests_csv_path = Path(sys.argv[1])
registry_path = Path(sys.argv[2])

# Generate list of tuples (UUID, count)
rows = []
with open(requests_csv_path) as f:
  reader = csv.reader(f)
  for row in reader:
    if row[2] == "user":
      # Get UUID and request_count
      rows.append((row[0], int(row[4])))
rows.sort(key=(lambda x: x[1]), reverse=True)

# Build a map from UUID -> name
registry = toml.load(registry_path / "Registry.toml")
uuid_to_name = {k: v["name"] for k, v in registry["packages"].items()}

results = []
for (uuid, count) in rows:
  name = uuid_to_name.get(uuid)
  if not name: continue
  results.append({ "uuid": uuid, "name": uuid_to_name.get(uuid), "count": count })

yaml.dump(results, sys.stdout, default_flow_style=False)
