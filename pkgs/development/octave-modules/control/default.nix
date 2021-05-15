{ buildOctavePackage
, lib
, fetchurl
, gfortran
, lapack, blas
}:

buildOctavePackage rec {
  pname = "control";
  version = "3.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0gjyjsxs01x0nyc4cgn3d5af17l3lzs8h4hsm57nxd3as48dbwgs";
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
