{
  lib,
  stdenv,
  writeScript,
  openssl,
}:

{ version, src, ... }:

stdenv.mkDerivation rec {
  pname = "matrix";
  inherit version src;
  inherit (src) passthru;

  setupHook = writeScript "matrix-setup-hook" ''
    matrixFixupHook() {
      runtimeDependencies+=('${lib.getLib openssl}')
    }

    preFixupHooks+=(matrixFixupHook)
  '';

  installPhase = ''
    runHook preInstall

    cp -r . "$out"

    runHook postInstall
  '';
}
