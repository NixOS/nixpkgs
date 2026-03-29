{
  lib,
  callPackage,
  buildFHSEnv,
  fetchFromGitHub,
  python3Packages,
  libz,

  extraRuntimeDependencies ? [ ],
}:
# Wrap ufbt in an FHS wrapper as it dynamically downloads and executes toolchains
let
  version = "0.2.6";
  ufbt-unwrapped = callPackage ./ufbt-unwrapped.nix { inherit version; };
in
buildFHSEnv {
  pname = "ufbt";
  inherit version;

  targetPkgs =
    pkgs:
    [
      ufbt-unwrapped
      libz
    ]
    ++ extraRuntimeDependencies;

  runScript = "ufbt";

  extraInstallCommands = ''
    ln -s ${ufbt-unwrapped}/bin/ufbt-bootstrap $out/bin/ufbt-bootstrap
  '';

  meta = {
    changelog = "https://github.com/flipperdevices/flipperzero-ufbt/releases/tag/v${version}";
    description = "Compact tool for building and debugging applications for Flipper Zero";
    homepage = "https://github.com/flipperdevices/flipperzero-ufbt";
    license = with lib.licenses; [
      gpl3
    ];
    maintainers = with lib.maintainers; [ mart-w ];
    mainProgram = "ufbt";
  };
}
