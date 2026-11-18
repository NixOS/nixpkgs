{
  lib,
  stdenv,
  zenity,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "file_picker";
  inherit version src;
  inherit (src) passthru;

  postPatch = lib.optionalString (lib.versionOlder version "10.3.0") ''
    substituteInPlace lib/src/linux/file_picker_linux.dart \
        --replace-fail "isExecutableOnPath('zenity')" "'${lib.getExe zenity}'"
  '';

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';
}
