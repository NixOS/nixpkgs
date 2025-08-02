{
  lib,
  stdenv,
  writeScript,
  olm,
}:

{ version, src, ... }:

stdenv.mkDerivation rec {
  pname = "olm";
  inherit version src;
  inherit (src) passthru;

  setupHook = writeScript "olm-setup-hook" ''
    olmFixupHook() {
      runtimeDependencies+=('${lib.getLib olm}')
    }

    preFixupHooks+=(olmFixupHook)
  '';

  installPhase = ''
    runHook preInstall

    cp -r . "$out"

    runHook postInstall
  '';
}
