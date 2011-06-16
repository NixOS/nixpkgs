{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "yasm-1.1.0";
  
  src = fetchurl {
    url = "http://www.tortall.net/projects/yasm/releases/${name}.tar.gz";
    sha256 = "e5d56b582f3d0c30ed5c4fc221063e4175602307ea645520889458133671c232";
  };

  meta = {
    homepage = http://www.tortall.net/projects/yasm/;
    description = "Complete rewrite of the NASM assembler";
    license = "BSD";
  };
}
