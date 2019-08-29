{ stdenv, fetchurl, boost, pkgconfig, librevenge, zlib }:

stdenv.mkDerivation rec {
  name = "libwps-${version}";
  version = "0.4.10";

  src = fetchurl {
    url = "mirror://sourceforge/libwps/${name}.tar.bz2";
    sha256 = "1adx2wawl0i16p8df80m6k6a137h709ip4zc0zlzr6wal8gpn0i4";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost librevenge zlib ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=implicit-fallthrough" ]; # newly detected by gcc-7

  meta = with stdenv.lib; {
    homepage = http://libwps.sourceforge.net/;
    description = "Microsoft Works document format import filter library";
    platforms = platforms.unix;
    license = licenses.lgpl21;
  };
}
