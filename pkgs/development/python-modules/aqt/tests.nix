{ runCommand, aqt, python39 }:

let
  inherit (aqt) pname version;
in
  runCommand "${pname}-tests" {
    nativeBuildInputs = [ (python39.withPackages (ps: [ ps.aqt ps.mypy ])) ];
  } ''
    mypy ${./addon_demo.py}
    if [ $? -eq 0 ]; then
      touch $out
    fi
  ''
