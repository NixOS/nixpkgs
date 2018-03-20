{ stdenv, fetchurl, static ? false }:

with stdenv.lib;

stdenv.mkDerivation {
  name = "libjpeg-9c";

  src = fetchurl {
    url = http://www.ijg.org/files/jpegsrc.v9c.tar.gz;
    sha256 = "1m3a137r7m14wd92a03qdvp4jfazc0657nzry7rqzs2p1xhkyfhz";
  };

  configureFlags = optional static "--enable-static --disable-shared";

  outputs = [ "bin" "dev" "out" "man" ];

  meta = {
    homepage = http://www.ijg.org/;
    description = "A library that implements the JPEG image file format";
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.unix;
  };
}
