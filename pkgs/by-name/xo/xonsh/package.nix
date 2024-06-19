{ lib
, callPackage
, extraPackages ? (ps: [ ])
, runCommand
}:

let
  xonsh-unwrapped = callPackage ./unwrapped.nix { };
  inherit (xonsh-unwrapped.passthru) python;

  pythonEnv = python.withPackages (ps: [
    (ps.toPythonModule xonsh-unwrapped)
  ] ++ extraPackages ps);
in
runCommand "xonsh-${xonsh-unwrapped.version}"
{
  inherit (xonsh-unwrapped) pname version meta;
  passthru = xonsh-unwrapped.passthru // { unwrapped = xonsh-unwrapped; };
} ''
  mkdir -p $out/bin
  for bin in ${lib.getBin xonsh-unwrapped}/bin/*; do
    ln -s ${pythonEnv}/bin/$(basename "$bin") $out/bin/
  done
''
