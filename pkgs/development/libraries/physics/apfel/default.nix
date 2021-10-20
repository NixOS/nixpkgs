{ lib, stdenv, fetchFromGitHub, gfortran, lhapdf, python2, zlib }:

stdenv.mkDerivation rec {
  pname = "apfel";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "scarrazza";
    repo = "apfel";
    rev = version;
    sha256 = "sha256-szEtSC/NouYlHSjVoX9Hoh7yQ0W82rVccYEF1L2tXoU=";
  };

  buildInputs = [ gfortran lhapdf python2 zlib ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A PDF Evolution Library";
    license     = licenses.gpl3;
    homepage    = "https://apfel.mi.infn.it/";
    platforms   = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
