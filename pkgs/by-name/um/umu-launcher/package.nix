{
  buildFHSEnv,
  lib,
  umu-launcher-unwrapped,
}:
buildFHSEnv {
  pname = "umu-launcher";
  inherit (umu-launcher-unwrapped) version meta;

  # Use umu-launcher-unwrapped from the package args, to simplify overriding
  targetPkgs = _: [ umu-launcher-unwrapped ];

  executableName = umu-launcher-unwrapped.meta.mainProgram;
  runScript = lib.getExe umu-launcher-unwrapped;

  extraInstallCommands = ''
    ln -s ${umu-launcher-unwrapped}/lib $out/lib
    ln -s ${umu-launcher-unwrapped}/share $out/share
  '';
}
