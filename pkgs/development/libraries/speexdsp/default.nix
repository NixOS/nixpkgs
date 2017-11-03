{ stdenv, fetchurl, autoreconfHook, pkgconfig, fftw }:

stdenv.mkDerivation rec {
  name = "speexdsp-1.2rc3";

  src = fetchurl {
    url = "http://downloads.us.xiph.org/releases/speex/${name}.tar.gz";
    sha256 = "1wcjyrnwlkayb20zdhp48y260rfyzg925qpjpljd5x9r01h8irja";
  };

  patches = [ ./build-fix.patch ];
  postPatch = "sed '3i#include <stdint.h>' -i ./include/speex/speexdsp_config_types.h.in";

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ fftw ];

  configureFlags = [
    "--with-fft=gpl-fftw3"
  ] ++ stdenv.lib.optional stdenv.isAarch64 "--disable-neon";

  meta = with stdenv.lib; {
    homepage = http://www.speex.org/;
    description = "An Open Source/Free Software patent-free audio compression format designed for speech";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
