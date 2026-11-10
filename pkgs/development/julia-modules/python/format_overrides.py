
import json
from pathlib import Path
import sys
import toml

overrides_path = Path(sys.argv[1])
out_path = Path(sys.argv[2])

with open(overrides_path, "r") as f:
  overrides = json.loads(f.read())

result = {}

for (uuid, artifacts) in overrides.items():
  if len(artifacts) == 0: continue

  for (name, info) in artifacts.items():
    result[info["sha1"]] = info["path"]

with open(out_path, "w") as f:
  toml.dump(result, f)
