
import json
from pathlib import Path
import sys
import toml

overrides_path = Path(sys.argv[1])
out_path = Path(sys.argv[2])

with open(overrides_path, "r") as f:
  overrides = json.loads(f.read())

with open(out_path, "w") as f:
  toml.dump(overrides, f)
