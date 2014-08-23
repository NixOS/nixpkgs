{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libconfig-${version}";
  version = "1.4.9";

  src = fetchurl {
    url = "http://www.hyperrealm.com/libconfig/${name}.tar.gz";
    sha256 = "0h9h8xjd36lky2r8jyc6hw085xwpslf0x6wyjvi960g6aa99gj09";
  };

  meta = with stdenv.lib; {
    homepage = http://www.hyperrealm.com/libconfig;
    description = "a simple library for processing structured configuration files";
    license = licenses.lgpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
