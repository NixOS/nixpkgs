{
  stdenv,
  zenity,
}:

{ version, src, ... }:

stdenv.mkDerivation rec {
  pname = "file_picker";
  inherit version src;
  inherit (src) passthru;

  postPatch = ''
    substituteInPlace lib/src/linux/file_picker_linux.dart \
        --replace-fail "isExecutableOnPath('zenity')" "'${zenity}/bin/zenity'"
  '';

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';
}
