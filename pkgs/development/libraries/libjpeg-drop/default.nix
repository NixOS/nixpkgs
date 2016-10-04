{ stdenv, fetchurl, static ? true }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libjpeg-drop-9b";

  srcs = [
    (fetchurl {
      url = http://www.ijg.org/files/jpegsrc.v9b.tar.gz;
      sha256 = "0lnhpahgdwlrkd41lx6cr90r199f8mc6ydlh7jznj5klvacd63r4";
    })
    (fetchurl {
      url = http://jpegclub.org/droppatch.v9b.tar.gz;
      sha256 = "022bnvpird7w5pwbfqpq7j7pwja5kp6x9k3sdypcy3g2nwwy2wwk";
    })
  ];

  postUnpack = ''
    rm jpegtran
    mv jpegtran.c jpeg-9b/jpegtran.c
    mv transupp.c jpeg-9b/transupp.c
    mv transupp.h jpeg-9b/transupp.h
  '';

  configureFlags = []
    ++ optional static [ "--enable-static" "--disable-shared" ];

  outputs = [ "bin" "dev" "out" "man" ];

  meta = {
    homepage = http://jpegclub.org/jpegtran/;
    description = "Experimental lossless crop 'n' drop (cut & paste) patches for libjpeg";
    license = stdenv.lib.licenses.free;
  };
}
