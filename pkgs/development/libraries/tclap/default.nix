{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tclap-1.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/tclap/${name}.tar.gz";
    sha256 = "sha256-GefbUoFUDxVDSHcLw6dIRXX09Umu+OAKq8yUs5X3c8k=";
  };

  meta = with lib; {
    homepage = "http://tclap.sourceforge.net/";
    description = "Templatized C++ Command Line Parser Library";
    platforms = platforms.all;
    license = licenses.mit;
  };
}
