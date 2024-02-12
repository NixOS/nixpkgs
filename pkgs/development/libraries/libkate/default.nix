{ lib, stdenv, fetchurl, libogg, libpng }:

stdenv.mkDerivation rec {
  pname = "libkate";
  version = "0.4.1";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libkate/${pname}-${version}.tar.gz";
    sha256 = "0s3vr2nxfxlf1k75iqpp4l78yf4gil3f0v778kvlngbchvaq23n4";
  };

  buildInputs = [ libogg libpng ];

  meta = with lib; {
    description = "A library for encoding and decoding Kate streams";
    longDescription = ''
      This is libkate, the reference implementation of a codec for the Kate
      bitstream format. Kate is a karaoke and text codec meant for encapsulation
      in an Ogg container. It can carry Unicode text, images, and animate
      them.'';
    homepage = "https://code.google.com/archive/p/libkate/";
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
