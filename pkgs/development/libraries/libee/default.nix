{ lib, stdenv, fetchurl, pkg-config, libestr }:
stdenv.mkDerivation rec {
  pname = "libee";
  version = "0.4.1";

  src = fetchurl {
    url = "http://www.libee.org/download/files/download/libee-${version}.tar.gz";
    sha256 = "09xhgzmsq0g3jsyj24vy67bhzk2fv971w5ixdkhfwgar70cw1nn0";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libestr];

  meta = {
    description = "An Event Expression Library inspired by CEE";
    homepage = "http://www.libee.org/";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "libee-convert";
    platforms = lib.platforms.unix;
  };
}
