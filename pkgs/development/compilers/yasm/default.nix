{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "yasm-1.0.0";
  
  src = fetchurl {
    url = http://www.tortall.net/projects/yasm/releases/yasm-1.0.0.tar.gz;
    sha256 = "0nd95r9y5r3p9mvdyj1yhvlz9zjw0id1g470c7i1p3p0x0n6zc06";
  };

  meta = {
    homepage = http://www.tortall.net/projects/yasm/;
    description = "Complete rewrite of the NASM assembler";
    license = "BSD";
  };
}
