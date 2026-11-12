{
  lib,
  stdenv,
  stdlib,
  swift,
  swiftpm,
}:

stdenv.mkDerivation {
  name = "test-swiftpm-backdeploy-references-stdlib";

  src = ./src;

  strictDeps = true;

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  doCheck = true;

  checkPhase = ''
    swift run -c release | grep 'x: 1;x: 2;x: 3;x: 4'
  '';

  postFixup = ''
    # This check has to be done post-fixup to make sure the stdlib’s rpath hook has run.
    foundStdlib=0
    foundSwift=0

    IFS= readarray -d $'\n' -t rpaths < <(objdump --macho --rpaths $out/bin/backdeploy-references-stdlib | tail -n +2)
    for rpath in "''${rpaths[@]}"; do
      if [[ "$rpath" =~ ${lib.escapeShellArg (lib.getLib stdlib)} ]]; then
        foundStdlib=1
      fi
      if [[ "$rpath" =~ ${lib.escapeShellArg (lib.getLib swift)} ]]; then
        foundSwift=1
      fi
    done
    rm -rf "$out"
    if [[ "$foundStdlib" == 0 || "$foundSwift" == 1 ]]; then
      exit 1
    else
      touch "$out"
    fi
  '';

  __structuredAttrs = true;

  # Backdeployment is only used on Darwin.
  meta.platforms = lib.platforms.darwin;
}
