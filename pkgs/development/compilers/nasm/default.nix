{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nasm-${version}";
  version = "2.11.06";
  
  src = fetchurl {
    url = "http://www.nasm.us/pub/nasm/releasebuilds/${version}/${name}.tar.bz2";
    sha256 = "0v1y1kx09nzmk8w4v79jxhn15fmi3g7l9nmgkn7ldjl1d5yxkdl7";
  };

  meta = with stdenv.lib; {
    homepage = http://www.nasm.us/;
    description = "An 80x86 and x86-64 assembler designed for portability and modularity";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
