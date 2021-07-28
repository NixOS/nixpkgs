{ lib, stdenv, fetchurl, static ? false }:

stdenv.mkDerivation rec {
  pname = "libjpeg";
  version = "9d";

  src = fetchurl {
    url = "http://www.ijg.org/files/jpegsrc.v${version}.tar.gz";
    sha256 = "1vkip9rz4hz8f31a2kl7wl7f772wg1z0fg1fbd1653wzwlxllhvc";
  };

  configureFlags = lib.optional static "--enable-static --disable-shared";

  outputs = [ "bin" "dev" "out" "man" ];

  meta = with lib; {
    homepage = "https://www.ijg.org/";
    description = "A library that implements the JPEG image file format";
    maintainers = with maintainers; [ ];
    license = licenses.free;
    platforms = platforms.unix;
  };
}
