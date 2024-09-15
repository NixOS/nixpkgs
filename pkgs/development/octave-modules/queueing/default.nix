{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "queueing";
  version = "1.2.7";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1yhw277i1qgmddf6wbfb6a4zrfhvplkmfr20q1l15z4xi8afnm6d";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/queueing/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Provides functions for queueing networks and Markov chains analysis";
    longDescription = ''
      The queueing package provides functions for queueing networks and Markov
      chains analysis. This package can be used to compute steady-state
      performance measures for open, closed and mixed networks with single or
      multiple job classes. Mean Value Analysis (MVA), convolution, and various
      bounding techniques are implemented. Furthermore, several transient and
      steady-state performance measures for Markov chains can be computed, such
      as state occupancy probabilities, mean time to absorption, time-averaged
      sojourn times and so forth. Discrete- and continuous-time Markov chains
      are supported.
    '';
  };
}
