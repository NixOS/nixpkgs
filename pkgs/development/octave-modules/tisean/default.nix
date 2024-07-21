{ buildOctavePackage
, lib
, fetchurl
# Octave dependencies
, signal # >= 1.3.0
# Build dependencies
, gfortran
}:

buildOctavePackage rec {
  pname = "tisean";
  version = "0.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0nc2d9h91glxzmpizxdrc2dablw4bqhqhzs37a394c36myk4xjdv";
  };

  nativeBuildInputs = [
    gfortran
  ];

  requiredOctavePackages = [
    signal
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/tisean/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Port of TISEAN 3.0.1";
    # Broken since octave 8.x update, and wasn't updated since 2021
    broken = true;
  };
}
