{
  lib,
  stdenv,
  xdg-user-dirs,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "xdg_directories";
  inherit version src;
  inherit (src) passthru;

  postPatch = ''
    substituteInPlace lib/xdg_directories.dart \
      --replace-fail "'xdg-user-dir'," "'${lib.getExe' xdg-user-dirs "xdg-user-dir"}',"
  '';

  installPhase = ''
    runHook preInstall

    cp -r . "$out"

    runHook postInstall
  '';
}
