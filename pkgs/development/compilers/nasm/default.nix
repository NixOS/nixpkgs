{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "nasm-2.09";
  
  src = fetchurl {
    url = http://www.nasm.us/pub/nasm/releasebuilds/2.09/nasm-2.09.tar.bz2;
    sha256 = "06kv1ii8d3jwq5mczbyx6zc7k1acdwjdfjblv78mglf161i82j4m";
  };

  meta = {
    homepage = http://www.nasm.us/;
    description = "An 80x86 and x86-64 assembler designed for portability and modularity";
  };
}
