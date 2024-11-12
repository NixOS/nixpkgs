{
  lib,
  python3,
  runCommand,
  # configurable options
  extraPackages ? (ps: [ ]),
}:

let
  pythonEnv = python3.withPackages
    (ps: [ ps.xonsh ] ++ extraPackages ps);
  xonsh = python3.pkgs.xonsh;
in
runCommand
  "xonsh-${xonsh.version}"
  {
    inherit (xonsh) pname version meta passthru;
  }
  ''
    mkdir -p $out/bin
    for bin in ${lib.getBin xonsh}/bin/*; do
      ln -s ${pythonEnv}/bin/$(basename "$bin") $out/bin/
    done
  ''
