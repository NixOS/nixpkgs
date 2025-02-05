{
  buildFHSEnv,
  lib,
  umu-launcher-unwrapped,
  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],
  withMultiArch ? true, # Many Wine games need 32-bit libraries.
}:
buildFHSEnv {
  pname = "umu-launcher";
  inherit (umu-launcher-unwrapped) version meta;

  targetPkgs =
    pkgs:
    [
      # Use umu-launcher-unwrapped from the package args, to support overriding
      umu-launcher-unwrapped
    ]
    ++ extraPkgs pkgs;
  multiPkgs = extraLibraries;
  multiArch = withMultiArch;

  executableName = umu-launcher-unwrapped.meta.mainProgram;
  runScript = lib.getExe umu-launcher-unwrapped;

  extraInstallCommands = ''
    ln -s ${umu-launcher-unwrapped}/lib $out/lib
    ln -s ${umu-launcher-unwrapped}/share $out/share
  '';
}
