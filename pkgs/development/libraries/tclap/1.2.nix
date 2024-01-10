{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "tclap";
  version = "1.2.5";

  src = fetchurl {
    url = "mirror://sourceforge/tclap/${pname}-${version}.tar.gz";
    sha256 = "sha256-u2SfdtrjXo0Ny6S1Ks/U4GLXh+aoG0P3pLASdRUxZaY=";
  };

  meta = with lib; {
    homepage = "https://tclap.sourceforge.net/";
    description = "Templatized C++ Command Line Parser Library";
    platforms = platforms.all;
    license = licenses.mit;
  };
}
