{
  lib,
  stdenv,
  callPackage,
  autoPatchelfHook,
  src,
}:

(stdenv.mkDerivation {
  inherit (src) name;
  inherit src;

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -r . "$out/bin/cache"

    runHook postInstall
  '';
}).overrideAttrs
  (
    if builtins.pathExists (./overrides + "/${src.flutterPlatform}.nix") then
      callPackage (./overrides + "/${src.flutterPlatform}.nix") { }
    else
      ({ ... }: { })
  )
