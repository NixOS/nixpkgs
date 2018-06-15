{ stdenv, fetchurl, boost, pkgconfig, librevenge, zlib }:

stdenv.mkDerivation rec {
  name = "libwps-${version}";
  version = "0.4.9";

  src = fetchurl {
    url = "mirror://sourceforge/libwps/${name}.tar.bz2";
    sha256 = "1wn5lvx7c9dp98d9akqjhkv5fk94725hbvqzbjpy1v8y4mm9knb6";
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
