{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "yasm-1.2.0";

  src = fetchurl {
    url = "http://www.tortall.net/projects/yasm/releases/${name}.tar.gz";
    sha256 = "0cfg7ji3ia2in628w42wrfvw2ixmmm4rghwmv2k202mraysgm3vn";
  };

  meta = {
    homepage = http://www.tortall.net/projects/yasm/;
    description = "Complete rewrite of the NASM assembler";
    license = "BSD";
    platforms = stdenv.lib.platforms.unix;
  };
}
