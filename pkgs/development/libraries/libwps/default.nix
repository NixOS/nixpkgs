{ stdenv, fetchurl, boost, pkgconfig, librevenge, zlib }:

stdenv.mkDerivation rec {
  name = "libwps-${version}";
  version = "0.4.3";

  src = fetchurl {
    url = "mirror://sourceforge/libwps/${name}.tar.bz2";
    sha256 = "0v1a0hj96i4jhb5833336s4zcslzb6md5cnmnrvgywx8cmw40c0c";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost librevenge zlib ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=implicit-fallthrough" ]; # newly detected by gcc-7

  meta = with stdenv.lib; {
    homepage = http://libwps.sourceforge.net/;
    description = "Microsoft Works document format import filter library";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
