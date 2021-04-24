{ lib, stdenv, fetchurl, libtiff, libjpeg, zlib }:

stdenv.mkDerivation rec {
  name = "lcms2-2.12";

  src = fetchurl {
    url = "mirror://sourceforge/lcms/${name}.tar.gz";
    sha256 = "sha256-GGY5hehkEARVrD5QdiXEOMNxA1TYXly7fNQEPhH+EPU=";
  };

  outputs = [ "bin" "dev" "out" ];

  propagatedBuildInputs = [ libtiff libjpeg zlib ];

  # See https://trac.macports.org/ticket/60656
  env.LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-Wl,-w";

  meta = with lib; {
    description = "Color management engine";
    homepage = "http://www.littlecms.com/";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
