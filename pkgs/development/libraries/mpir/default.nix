{ stdenv, fetchurl, m4, which, yasm }:

stdenv.mkDerivation rec {
  pname = "mpir";
  version = "3.0.0";

  nativeBuildInputs = [ m4 which yasm ];

  src = fetchurl {
    url = "http://mpir.org/mpir-${version}.tar.bz2";
    sha256 = "1fvmhrqdjs925hzr2i8bszm50h00gwsh17p2kn2pi51zrxck9xjj";
  };

  configureFlags = [ "--enable-cxx" ];

  meta = {
    inherit version;
    description = ''A highly optimised library for bignum arithmetic forked from GMP'';
    license = stdenv.lib.licenses.lgpl3Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
    downloadPage = "http://mpir.org/downloads.html";
    homepage = "http://mpir.org/";
    updateWalker = true;
  };
}
