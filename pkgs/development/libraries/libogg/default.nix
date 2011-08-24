{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libogg-1.2.2";
  
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/ogg/${name}.tar.gz";
    sha256 = "1fngv23r8anbf2f2x7s2bh1isxnw287gbc7mhh9g1m96pis0a05b";
  };

  meta = {
    homepage = http://xiph.org/ogg/;
  };
}
