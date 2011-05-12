{stdenv, fetchurl, nasm}:

stdenv.mkDerivation rec {
  name = "xvidcore-1.3.1";
  
  src = fetchurl {
    url = "http://downloads.xvid.org/downloads/${name}.tar.bz2";
    sha256 = "0r1x00fgm7cbb7i9p17p9l0p4b82gig6sm0mbs6qrz84kd2fh6n5";
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

