{ stdenv, fetchurl, static ? false }:

with stdenv.lib;

stdenv.mkDerivation {
  name = "libjpeg-9c";

  src = fetchurl {
    url = http://www.ijg.org/files/jpegsrc.v9c.tar.gz;
    sha256 = "08kixcf3a7s9x91174abjnk1xbvj4v8crdc73zi4k9h3jfbm00k5";
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
