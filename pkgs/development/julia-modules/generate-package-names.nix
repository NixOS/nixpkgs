{ callPackage
, python3
, runCommand
}:

let
  registry = callPackage ./registry.nix {};

in

runCommand "julia-package-names.nix" { buildInputs = [(python3.withPackages (ps: [ps.toml]))]; } ''
  export OUT="$out"

  python - <<EOF

  import json
  import os
  from pathlib import Path
  import toml

  registry = packageToml = toml.load(Path("${registry}") / "Registry.toml")

  with open(os.environ["OUT"], "w") as f:
    f.write("[\n")
    for name in sorted(v["name"] for k, v in registry["packages"].items()):
      f.write('  "' + name + '"\n')
    f.write("]")

  EOF
''
