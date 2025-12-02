{
  lib,
  steam,
  umu-launcher-unwrapped,
  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],
  extraProfile ? "", # string to append to shell profile
  extraEnv ? { }, # Environment variables to include in shell profile
}:
steam.buildRuntimeEnv {
  pname = "umu-launcher";
  inherit (umu-launcher-unwrapped) version meta;

  extraPkgs = pkgs: [ umu-launcher-unwrapped ] ++ extraPkgs pkgs;
  inherit
    extraLibraries
    extraProfile
    extraEnv
    ;

  executableName = umu-launcher-unwrapped.meta.mainProgram;
  runScript = lib.getExe umu-launcher-unwrapped;

  # Legendary spawns UMU, doesn't wait for it to exit,
  # and immediately exits itself. This makes it so we can't
  # die with parent, because parent is already dead.
  dieWithParent = false;

  extraInstallCommands = ''
    ln -s ${umu-launcher-unwrapped}/lib $out/lib
    ln -s ${umu-launcher-unwrapped}/share $out/share
  '';
}
