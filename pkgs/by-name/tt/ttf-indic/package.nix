{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ttf-indic";
  version = "0.2";

  src = fetchurl {
    url = "https://www.indlinux.org/downloads/files/indic-otf-${version}.tar.gz";
    hash = "sha256-ZFmg1JanAf3eeF7M+yohrXYSUb0zLgNSFldEMzkhXnI=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype OpenType/*.ttf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.indlinux.org/wiki/index.php/Downloads";
    description = "Indic Opentype Fonts collection";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.akssri ];
    platforms = platforms.all;
  };
}
