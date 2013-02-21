{ stdenv, fetchurl, boost, libwpd, libwpg, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libvisio-0.0.19";

  src = fetchurl {
    url = "http://dev-www.libreoffice.org/src/${name}.tar.xz";
    sha256 = "1iqkz280mi066bdccyxagkqm41i270nx01cacvgjq2pflgd3njd1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost libwpd libwpg ];

  configureFlags = "--disable-werror";

  meta = {
    description = "A library providing ability to interpret and import visio diagrams into various applications";
    homepage = http://www.freedesktop.org/wiki/Software/libvisio;
    platforms = stdenv.lib.platforms.gnu; # random choice
  };
}
