{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tclap-1.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/tclap/${name}.tar.gz";
    sha256 = "0dsqvsgzam3mypj2ladn6v1yjq9zd47p3lg21jx6kz5azkkkn0gm";
  };

  meta = {
    homepage = http://tclap.sourceforge.net/;
    description = "Templatized C++ Command Line Parser Library";
    platforms = stdenv.lib.platforms.all;
  };
}
