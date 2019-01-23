{ stdenv, fetchzip }:

let
  version = "0.133";
in stdenv.mkDerivation {
  name = "culmus-${version}";

  src = fetchzip {
    url = "mirror://sourceforge/culmus/culmus/${version}/culmus-${version}.tar.gz";
    sha256 = "0q80j3vixn364sc23hcy6098rkgy0kb4p91lky6224am1dwn2qmr";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/{truetype,type1}
    cp -v *.pfa $out/share/fonts/type1/
    cp -v *.afm $out/share/fonts/type1/
    cp -v fonts.scale-type1 $out/share/fonts/type1/fonts.scale
    cp -v *.ttf $out/share/fonts/truetype/
    cp -v *.otf $out/share/fonts/truetype/
    cp -v fonts.scale-ttf $out/share/fonts/truetype/fonts.scale
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
