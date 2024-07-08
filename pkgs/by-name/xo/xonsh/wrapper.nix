{
  lib,
  runCommand,
  xonsh,
  # configurable options
  extraPackages ? (ps: [ ]),
}:

let
  inherit (xonsh.passthru) python;

  pythonEnv = python.withPackages
    (ps: [ (ps.toPythonModule xonsh) ] ++ extraPackages ps);
in
runCommand
  "xonsh-wrapped-${xonsh.version}"
  {
    inherit (xonsh) pname version meta passthru;
  }
  ''
    mkdir -p $out/bin
    for bin in ${lib.getBin xonsh}/bin/*; do
      ln -s ${pythonEnv}/bin/$(basename "$bin") $out/bin/
    done
  ''
