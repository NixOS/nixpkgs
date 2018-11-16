{ stdenv, fetchurl, gfortran }:

stdenv.mkDerivation rec {
  name = "QCDNUM-${version}";
  version = "17-01-14";

  src = fetchurl {
    url = "http://www.nikhef.nl/user/h24/qcdnum-files/download/qcdnum${builtins.replaceStrings ["-"] [""] version}.tar.gz";
    sha256 = "199s6kgmszxgjzd9214mpx3kyplq2q6987sii67s5xkg10ynyv31";
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
