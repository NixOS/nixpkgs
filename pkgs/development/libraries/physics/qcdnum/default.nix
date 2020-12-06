{ stdenv, fetchurl, gfortran, zlib }:

stdenv.mkDerivation rec {
  pname = "QCDNUM";
  version = "17-01-15";

  src = fetchurl {
    url = "http://www.nikhef.nl/user/h24/qcdnum-files/download/qcdnum${builtins.replaceStrings ["-"] [""] version}.tar.gz";
    sha256 = "0ibk1sppss45qh0g8i2c99alkx82xdbss3p55f5367bxjx4iqvvg";
  };

  nativeBuildInputs = [ gfortran ];
  buildInputs = [ zlib ];

  enableParallelBuilding = true;

  meta = {
    description = "A very fast QCD evolution program written in FORTRAN77";
    license     = stdenv.lib.licenses.gpl3;
    homepage    = "https://www.nikhef.nl/~h24/qcdnum/index.html";
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
