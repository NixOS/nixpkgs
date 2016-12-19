{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nasm-${version}";
  version = "2.11.08";

  src = fetchurl {
    url = "http://www.nasm.us/pub/nasm/releasebuilds/${version}/${name}.tar.bz2";
    sha256 = "0ialkla6i63j8fpv840jy7k5mdf2wbqr98bvbcq0dp0b38ls18wx";
  };

  meta = with stdenv.lib; {
    homepage = http://www.nasm.us/;
    description = "An 80x86 and x86-64 assembler designed for portability and modularity";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
