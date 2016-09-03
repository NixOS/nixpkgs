{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libomxil-bellagio-${version}";
  version = "0.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/omxil/omxil/Bellagio%20${version}/${name}.tar.gz";
    sha256 = "0k6p6h4npn8p1qlgq6z3jbfld6n1bqswzvxzndki937gr0lhfg2r";
  };
  
  patches = [ ./fedora-fixes.patch ];

  meta = with stdenv.lib; {
    homepage = http://sourceforge.net/projects/omxil/;
    description = "An opensource implementation of the Khronos OpenMAX Integration Layer API to access multimedia components";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
