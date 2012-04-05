{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libconfig-${version}";
  version = "1.4.8";

  src = fetchurl {
    url = "http://www.hyperrealm.com/libconfig/${name}.tar.gz";
    sha256 = "1v817hy9y416i64ly17xdmgrn62qwj225wqakdzqr2j3pygm1c8q";
  };

  meta = with stdenv.lib; {
    homepage = http://www.hyperrealm.com/libconfig;
    description = "a simple library for processing structured configuration files";
    license = licenses.lgpl3;
    maintainers = [ maintainers.goibhniu ];
  };
}
