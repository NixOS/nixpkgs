{ runCommand, anki, python39 }:

let
  inherit (anki) pname version;
in
  runCommand "${pname}-tests" {
    nativeBuildInputs = [ (python39.withPackages (ps: [ ps.anki ps.mypy ])) ];
  } ''
    mypy ${./addon_demo.py}
    if [ $? -eq 0 ]; then
      touch $out
    fi
  ''
