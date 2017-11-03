{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libconfig-${version}";
  version = "1.5";

  src = fetchurl {
    url = "http://www.hyperrealm.com/libconfig/${name}.tar.gz";
    sha256 = "e31daa390d8e4461c8830512fe2e13ba1a3d6a02a2305a02429eec61e68703f6";
  };

  meta = with stdenv.lib; {
    homepage = http://www.hyperrealm.com/libconfig;
    description = "A simple library for processing structured configuration files";
    license = licenses.lgpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
