{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "tclap";
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://sourceforge/tclap/${pname}-${version}.tar.gz";
    sha256 = "sha256-Y0xbWduxzLydal9t5JSiV+KaP1nctvwwRF/zm0UYhXQ=";
  };

  meta = with lib; {
    homepage = "http://tclap.sourceforge.net/";
    description = "Templatized C++ Command Line Parser Library";
    platforms = platforms.all;
    license = licenses.mit;
  };
}
