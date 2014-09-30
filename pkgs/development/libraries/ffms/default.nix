{ stdenv, fetchurl, zlib, ffmpeg, pkgconfig }:

stdenv.mkDerivation rec {
  name = "ffms-2.20";

  src = fetchurl {
    url = https://codeload.github.com/FFMS/ffms2/tar.gz/2.20;
    name = "${name}.tar.gz";
    sha256 = "183klnhl57zf0i8xlr7yvj89ih83pzd48c37qpr57hjn4wbq1n67";
  };

  NIX_CFLAGS_COMPILE = "-fPIC";

  buildInputs = [ zlib ffmpeg pkgconfig ];

  meta = {
    homepage = http://code.google.com/p/ffmpegsource/;
    description = "Libav/ffmpeg based source library for easy frame accurate access";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
