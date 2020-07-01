{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.5.1";
  pname = "libmpeg2";

  src = fetchurl {
    url = "http://libmpeg2.sourceforge.net/files/${pname}-${version}.tar.gz";
    sha256 = "1m3i322n2fwgrvbs1yck7g5md1dbg22bhq5xdqmjpz5m7j4jxqny";
  };

  # Otherwise clang fails with 'duplicate symbol ___sputc'
  buildFlags = stdenv.lib.optional stdenv.isDarwin "CFLAGS=-std=gnu89";

  meta = {
    homepage = "http://libmpeg2.sourceforge.net/";
    description = "A free library for decoding mpeg-2 and mpeg-1 video streams";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
