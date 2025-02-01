{
  stdenv,
  lib,
  writeScript,
  cairo,
  fribidi,
}:

{ version, src, ... }:

stdenv.mkDerivation rec {
  pname = "handy-window";
  inherit version src;
  inherit (src) passthru;

  setupHook = writeScript "${pname}-setup-hook" ''
    handyWindowConfigureHook() {
      export CFLAGS="$CFLAGS -isystem ${lib.getDev fribidi}/include/fribidi -isystem ${lib.getDev cairo}/include"
    }

    postConfigureHooks+=(handyWindowConfigureHook)
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    ln -s '${src}'/* "$out"

    runHook postInstall
  '';
}
