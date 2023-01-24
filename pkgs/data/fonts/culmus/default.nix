{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "culmus";
  version = "0.133";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-wMaHN0LQdUT2us8q1S65yzkpdNVkJ5ONwd+8g5nGTQU=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/{truetype,type1}
    cp -v *.pfa $out/share/fonts/type1/
    cp -v *.afm $out/share/fonts/type1/
    cp -v fonts.scale-type1 $out/share/fonts/type1/fonts.scale
    cp -v *.ttf $out/share/fonts/truetype/
    cp -v *.otf $out/share/fonts/truetype/
    cp -v fonts.scale-ttf $out/share/fonts/truetype/fonts.scale

    runHook postInstall
  '';

  meta = {
    description = "Culmus Hebrew fonts";
    longDescription = "The Culmus project aims at providing the Hebrew-speaking GNU/Linux and Unix community with a basic collection of Hebrew fonts for X Windows.";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2;
    homepage = "http://culmus.sourceforge.net/";
    downloadPage = "http://culmus.sourceforge.net/download.html";
  };
}
