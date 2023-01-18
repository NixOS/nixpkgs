{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "lao";
  version = "0.0.20060226";

  src = fetchurl {
    url = "mirror://debian/pool/main/f/fonts-${pname}/fonts-${pname}_${version}.orig.tar.xz";
    hash = "sha256-DlgdyfhxxzVkNIL+NGsQ+PRlNkCuG3v2OahkIEYx60o=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts
    cp Phetsarath_OT.ttf $out/share/fonts

    runHook postInstall
  '';

  meta = with lib; {
    description = "TrueType font for Lao language";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ serge ];
    platforms = platforms.all;
  };
}
