{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "nasm-2.08.01";
  
  src = fetchurl {
    url = "mirror://sourceforge/nasm/${name}.tar.bz2";
    sha256 = "1ilbvn5hfwhbfxsxdcnnpxy640hqgjjp5wlhfjh7biy0h49rm6q4";
  };

  meta = {
    homepage = http://www.nasm.us/;
    description = "An 80x86 and x86-64 assembler designed for portability and modularity";
  };
}
