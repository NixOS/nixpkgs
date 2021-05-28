{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "openlibm";
  version = "0.7.1";
  src = fetchurl {
    url = "https://github.com/JuliaLang/openlibm/archive/v${version}.tar.gz";
    sha256 = "0yg8sfibr38hpb4s5ri7i0ivp96c7khdwhlxngjiymvl3jvm5cnl";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "High quality system independent, portable, open source libm implementation";
    homepage = "https://www.openlibm.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
    platforms = stdenv.lib.platforms.all;
  };
}
