{stdenv, fetchurl, nasm}:

stdenv.mkDerivation rec {
  name = "xvidcore-1.2.2";
  
  src = fetchurl {
    url = http://downloads.xvid.org/downloads/xvidcore-1.2.2.tar.bz2;
    sha256 = "04bd1clv90i5pdwh6mz3mskyzmxyx5l2nx7lyyb8nhw9whnn0ap4";
  };

  preConfigure = ''
    cd build/generic
  '';

  buildInputs = [ nasm ];
  
  meta = {
    description = "MPEG-4 video codec for PC";
    homepage = http://www.xvid.org/;
    license = "GPLv2+";
  };
}

