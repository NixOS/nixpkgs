{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "kacst";
  version = "2.01";

  src = fetchurl {
    url = "mirror://debian/pool/main/f/fonts-${pname}/fonts-${pname}_${version}+mry.orig.tar.bz2";
    hash = "sha256-byiZzpYiMU6kJs+NSISfHPFzAnJtc8toNIbV/fKiMzg=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts
    cp -R kacst $out/share/fonts

    runHook postInstall
  '';

  meta = with lib; {
    description = "KACST Latin-Arabic TrueType fonts";
    license = licenses.gpl2Only;
    maintainers = with lib.maintainers; [ serge ];
    platforms = platforms.all;
  };
}
