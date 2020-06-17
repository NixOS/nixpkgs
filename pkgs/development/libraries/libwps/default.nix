{ stdenv, fetchurl, boost, pkgconfig, librevenge, zlib }:

stdenv.mkDerivation rec {
  pname = "libwps";
  version = "0.4.11";

  src = fetchurl {
    url = "mirror://sourceforge/libwps/${pname}-${version}.tar.bz2";
    sha256 = "11dg7q6mhvppfzsbzdlxldnsgapvgw17jlj1mca5jy4afn0zvqj8";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost librevenge zlib ];

  NIX_CFLAGS_COMPILE = "-Wno-error=implicit-fallthrough";

  meta = with stdenv.lib; {
    homepage = "http://libwps.sourceforge.net/";
    description = "Microsoft Works document format import filter library";
    platforms = platforms.unix;
    license = licenses.lgpl21;
  };
}
