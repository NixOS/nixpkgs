{
  buildFHSEnv,
  lib,
  steam,
  umu-launcher-unwrapped,
  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],
  extraProfile ? "", # string to append to shell profile
  extraEnv ? { }, # Environment variables to include in shell profile
  withMultiArch ? true, # Many Wine games need 32-bit libraries.
}:
let
  # Steam is not a dependency, but we re-use some of its implementation
  steam' = steam.override {
    inherit extraEnv extraProfile;
  };
in
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

  # For umu & proton, we need roughly the same environment as Steam.
  # For simplicity, we use Steam's `profile` implementation.
  # See https://github.com/NixOS/nixpkgs/pull/381047
  # And https://github.com/NixOS/nixpkgs/issues/297662#issuecomment-2647656699
  inherit (steam'.args) profile;
}
