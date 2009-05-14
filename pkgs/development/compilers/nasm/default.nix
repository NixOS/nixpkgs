{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "nasm-2.05.01";
  
  src = fetchurl {
    url = "mirror://sourceforge/nasm/${name}.tar.bz2";
    sha256 = "0p2rlshd68m2h7psyjz4440grxwryxppqzchx7cbmzahqr2yy1lj";
  };

  meta = {
    homepage = http://www.nasm.us/;
    description = "An 80x86 and x86-64 assembler designed for portability and modularity";
  };
}
