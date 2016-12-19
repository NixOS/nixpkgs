{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "culmus-${version}";
  version = "0.130";

  src = fetchurl {
    url = "mirror://sourceforge/culmus/culmus/${version}/culmus-${version}.tar.gz";
    sha256 = "908583e388bc983a63df4f38f7130eac69fc19539952031408bb3c627846f9c1";
  };
  
  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype/
  '';
  
  meta = {
    description = "Culmus Hebrew fonts";
    longDescription = "The Culmus project aims at providing the Hebrew-speaking GNU/Linux and Unix community with a basic collection of Hebrew fonts for X Windows.";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl2;
    homepage = http://culmus.sourceforge.net/;
    downloadPage = http://culmus.sourceforge.net/download.html;
  };
}
