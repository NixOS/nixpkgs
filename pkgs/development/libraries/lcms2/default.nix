{ lib, stdenv, fetchurl, libtiff, libjpeg, zlib }:

stdenv.mkDerivation rec {
  pname = "lcms2";
  version = "2.12";

  src = fetchurl {
    url = "mirror://sourceforge/lcms/${pname}-${version}.tar.gz";
    sha256 = "sha256-GGY5hehkEARVrD5QdiXEOMNxA1TYXly7fNQEPhH+EPU=";
  };

  outputs = [ "bin" "dev" "out" ];

  propagatedBuildInputs = [ libtiff libjpeg zlib ];

  # See https://trac.macports.org/ticket/60656
  LDFLAGS = if stdenv.hostPlatform.isDarwin then "-Wl,-w" else null;

  meta = with lib; {
    description = "Color management engine";
    homepage = "http://www.littlecms.com/";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
