{ stdenv, fetchurl, boost, libwpd, libwpg, pkgconfig, zlib, gperf
, librevenge, libxml2, icu, perl
}:

stdenv.mkDerivation rec {
  name = "libvisio-0.1.0";

  src = fetchurl {
    url = "http://dev-www.libreoffice.org/src/${name}.tar.bz2";
    sha256 = "1vpb7nbk5qh6w3jz9rl9w8p25invcvj46parb9ld13h9777kyf0j";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost libwpd libwpg zlib gperf librevenge libxml2 icu perl ];

  configureFlags = "--disable-werror";

  meta = {
    description = "A library providing ability to interpret and import visio diagrams into various applications";
    homepage = http://www.freedesktop.org/wiki/Software/libvisio;
    platforms = stdenv.lib.platforms.gnu; # random choice
  };
}
