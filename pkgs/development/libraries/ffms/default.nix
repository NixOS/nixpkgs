{ stdenv, fetchurl, zlib, ffmpeg, pkgconfig }:

stdenv.mkDerivation rec {
  name = "ffms-2.21";

  src = fetchurl {
    url = https://codeload.github.com/FFMS/ffms2/tar.gz/2.21;
    name = "${name}.tar.gz";
    sha256 = "00h2a5yhvr1qzbrzwbjv1ybxrx25lchgral6yxv36aaf4pi3rhn2";
  };

  NIX_CFLAGS_COMPILE = "-fPIC";

  buildInputs = [ zlib ffmpeg pkgconfig ];

  meta = {
    homepage = http://code.google.com/p/ffmpegsource/;
    description = "Libav/ffmpeg based source library for easy frame accurate access";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
