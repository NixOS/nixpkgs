{
  stdenv,
  lib,
  writeScript,
  openssl,
}:

{ version, src, ... }:

stdenv.mkDerivation rec {
  pname = "matrix";
  inherit version src;
  inherit (src) passthru;

  setupHook = writeScript "${pname}-setup-hook" ''
    matrixFixupHook() {
      runtimeDependencies+=('${lib.getLib openssl}')
    }

    preFixupHooks+=(matrixFixupHook)
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    ln -s '${src}'/* "$out"

    runHook postInstall
  '';
}
