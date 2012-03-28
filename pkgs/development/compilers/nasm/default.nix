{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nasm-2.10";
  
  src = fetchurl {
    url = "http://www.nasm.us/pub/nasm/releasebuilds/2.10/${name}.tar.bz2";
    sha256 = "1wcxm0il06b17wjarw8pbf9bagjhfcf7yayahmyip03qkfka2yk8";
  };

  meta = {
    homepage = http://www.nasm.us/;
    description = "An 80x86 and x86-64 assembler designed for portability and modularity";
  };
}
