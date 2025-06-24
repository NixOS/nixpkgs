{
  lib,
  stdenv,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "flutter_rust_bridge";
  inherit version src;
  inherit (src) passthru;

  postPatch = lib.optionalString (lib.versionAtLeast version "2.0.0") ''
    substituteInPlace lib/src/cli/build_web/executor.dart \
      --replace-fail "'-Z'," "" \
      --replace-fail "'build-std=std,panic_abort'," ""
  '';

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';
}
