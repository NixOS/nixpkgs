{ lib, stdenv, fetchurl, libtiff, libjpeg, zlib }:

stdenv.mkDerivation rec {
  pname = "lcms2";
  version = "2.13.1";

  src = fetchurl {
    url = "mirror://sourceforge/lcms/${pname}-${version}.tar.gz";
    sha256 = "sha256-1HPnlueyfFrwG9bRVS1CtFtDRX5xgs6ZA/OLt0ggO4g=";
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
