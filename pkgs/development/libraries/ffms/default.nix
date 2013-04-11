{ stdenv, fetchurl, zlib, ffmpeg, pkgconfig }:

stdenv.mkDerivation {
  name = "ffms-2.17";
  
  src = fetchurl {
    url = http://ffmpegsource.googlecode.com/files/ffms-2.17-src.tar.bz2;
    sha256 = "0gb42hrwnldz3zjlk4llx85dvxysxlfrdf5yy3fay8r8k1vpl7wr";
  };

  NIX_CFLAGS_COMPILE = "-fPIC";

  buildInputs = [ zlib ffmpeg pkgconfig ];

  meta = {
    homepage = http://code.google.com/p/ffmpegsource/;
    description = "Libav/ffmpeg based source library for easy frame accurate access";
    license = "MIT";
  };
}
