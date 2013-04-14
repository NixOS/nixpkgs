{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "log4cpp-1.1";
  
  src = fetchurl {
    url = "mirror://sourceforge/log4cpp/${name}.tar.gz";
    sha256 = "1d386ws9v6f9bxma4dh5m6nzr4k2rv5q96xl5bp5synlmghd2ny2";
  };

  meta = {
    homepage = http://log4cpp.sourceforge.net/;
    description = "A logging framework for C++ patterned after Apache log4j";
    license = "LGPLv2.1+";
  };
}
