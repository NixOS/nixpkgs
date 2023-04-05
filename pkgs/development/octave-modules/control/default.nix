{ buildOctavePackage
, lib
, fetchurl
, gfortran
, lapack, blas
}:

buildOctavePackage rec {
  pname = "control";
  version = "3.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-U/o0RQoHdDhPP3xuiR9gCFb60CKrA30bpc/dH/ozDpg=";
  };

  nativeBuildInputs = [
    gfortran
  ];

  buildInputs = [
    lapack blas
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/control/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Computer-Aided Control System Design (CACSD) Tools for GNU Octave, based on the proven SLICOT Library";
  };
}
