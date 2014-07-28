{ stdenv, fetchurl, zlib, ffmpeg, pkgconfig }:

stdenv.mkDerivation rec {
  name = "ffms-2.19";

  src = fetchurl {
    url = https://codeload.github.com/FFMS/ffms2/tar.gz/2.19;
    name = "${name}.tar.gz";
    sha256 = "0498si8bzwyxxq0f1yc6invzb1lv1ab436gwzn9418839x8pj4vg";
  };

  NIX_CFLAGS_COMPILE = "-fPIC";

  buildInputs = [ zlib ffmpeg pkgconfig ];

  meta = {
    homepage = http://code.google.com/p/ffmpegsource/;
    description = "Libav/ffmpeg based source library for easy frame accurate access";
    license = stdenv.lib.licenses.mit;
  };
}
