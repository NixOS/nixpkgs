{ stdenv, fetchurl, pkgconfig, freetype, libXft, pango, fontconfig, cmake }:

stdenv.mkDerivation rec {
  version = "1.2.3";
  name = "graphite2-${version}";
  
  src = fetchurl {
    url = "mirror://sourceforge/silgraphite/graphite2/${name}.tgz";
    sha256 = "1xgwnd81gm6p293x8paxb3yisnvpj5qnv1dzr7bjdi7b7h00ls7g";
  };

  buildInputs = [pkgconfig freetype libXft pango fontconfig cmake];

  NIX_CFLAGS_COMPILE = "-I${freetype}/include/freetype2";

  meta = {
    description = "An advanced font engine";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
