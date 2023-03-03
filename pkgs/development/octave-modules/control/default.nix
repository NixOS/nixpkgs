{ buildOctavePackage
, lib
, fetchurl
, gfortran
, lapack, blas
}:

buildOctavePackage rec {
  pname = "control";
  version = "3.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0vndbzix34vfzdlsz57bgkyg31as4kv6hfg9pwrcqn75bzzjsivw";
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
