{ stdenv, fetchurl, boost, pkgconfig, librevenge, zlib }:

stdenv.mkDerivation rec {
  pname = "libwps";
  version = "0.4.12";

  src = fetchurl {
    url = "mirror://sourceforge/libwps/${pname}-${version}.tar.bz2";
    sha256 = "16c6vq6hhi5lcvgyb9dwarr3kz69l1g5fs39b2hwqhkwzx5igpcl";
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
