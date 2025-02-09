{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "tibetan-machine";
  version = "1.901b";

  src = fetchurl {
    url = "mirror://debian/pool/main/f/fonts-${pname}/fonts-${pname}_${version}.orig.tar.bz2";
    hash = "sha256-c/1Sgv7xKHpsJGjY9ZY2qOJHShGHL1robvphFNJOt5w=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts
    cp *.ttf $out/share/fonts

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tibetan Machine - an OpenType Tibetan, Dzongkha and Ladakhi font";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ serge ];
    platforms = platforms.all;
  };
}
