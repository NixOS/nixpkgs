{
  lib,
  stdenv,
  writeScript,
  cairo,
  fribidi,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "handy_window";
  inherit version src;
  inherit (src) passthru;

  setupHook = writeScript "handy_window-setup-hook" ''
    handyWindowConfigureHook() {
      export CFLAGS="$CFLAGS -isystem ${lib.getDev fribidi}/include/fribidi -isystem ${lib.getDev cairo}/include"
    }

    postConfigureHooks+=(handyWindowConfigureHook)
  '';

  installPhase = ''
    runHook preInstall

    cp -r . "$out"

    runHook postInstall
  '';
}
