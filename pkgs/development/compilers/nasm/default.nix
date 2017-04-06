{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nasm-${version}";
  version = "2.12.02";

  src = fetchurl {
    url = "http://www.nasm.us/pub/nasm/releasebuilds/${version}/${name}.tar.bz2";
    sha256 = "097318bjxvmffbjfd1k89parc04xf5jfxg2rr93581lccwf8kc00";
  };

  meta = with stdenv.lib; {
    homepage = http://www.nasm.us/;
    description = "An 80x86 and x86-64 assembler designed for portability and modularity";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
