{ stdenv, fetchurl, gfortran }:

stdenv.mkDerivation rec {
  name = "QCDNUM-${version}";
  version = "17-01-13";

  src = fetchurl {
    url = "http://www.nikhef.nl/user/h24/qcdnum-files/download/qcdnum${builtins.replaceStrings ["-"] [""] version}.tar.gz";
    sha256 = "0568rjviwvjkfihq2ka7g91vmialr31ryn7c69iqf13rcv5vzcw7";
  };

  nativeBuildInputs = [ gfortran ];

  enableParallelBuilding = true;

  meta = {
    description = "QCDNUM is a very fast QCD evolution program written in FORTRAN77";
    license     = stdenv.lib.licenses.gpl3;
    homepage    = https://www.nikhef.nl/~h24/qcdnum/index.html;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
