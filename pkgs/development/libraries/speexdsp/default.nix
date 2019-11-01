{ stdenv, fetchurl, autoreconfHook, pkgconfig, fftw }:

stdenv.mkDerivation rec {
  name = "speexdsp-1.2.0";

  src = fetchurl {
    url = "http://downloads.us.xiph.org/releases/speex/${name}.tar.gz";
    sha256 = "0wa7sqpk3x61zz99m7lwkgr6yv62ml6lfgs5xja65vlvdzy44838";
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
    homepage = https://www.speex.org/;
    description = "An Open Source/Free Software patent-free audio compression format designed for speech";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
