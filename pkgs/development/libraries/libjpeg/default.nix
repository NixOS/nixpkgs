{ lib, stdenv, fetchurl, static ? false }:

with lib;

stdenv.mkDerivation {
  name = "libjpeg-9d";

  src = fetchurl {
    url = "http://www.ijg.org/files/jpegsrc.v9d.tar.gz";
    sha256 = "0clwys9lcqlxqgcw8s1gwfm5ix2zjlqpklmd3mbvqmj5ibj51jwr";
  };

  configureFlags = optional static "--enable-static --disable-shared";

  outputs = [ "bin" "dev" "out" "man" ];

  meta = {
    homepage = "http://www.ijg.org/";
    description = "A library that implements the JPEG image file format";
    license = lib.licenses.free;
    platforms = lib.platforms.unix;
  };
}
