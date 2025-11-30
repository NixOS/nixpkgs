{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ttf-bitstream-vera";
  version = "1.10";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    hash = "sha256-21sn33u7MYA269t1rNPpjxvW62YI+3CmfUeM0kPReNw=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype *.ttf

    runHook postInstall
  '';

  meta = { };
}
