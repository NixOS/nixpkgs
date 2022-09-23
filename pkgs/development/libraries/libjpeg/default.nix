{ lib, stdenv, fetchurl, static ? false }:

stdenv.mkDerivation rec {
  pname = "libjpeg";
  version = "9e";

  src = fetchurl {
    url = "http://www.ijg.org/files/jpegsrc.v${version}.tar.gz";
    sha256 = "sha256-QHfWpqda6wGIT3CJGdJZNMkzBeSffj8225EpMg5vTz0=";
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
