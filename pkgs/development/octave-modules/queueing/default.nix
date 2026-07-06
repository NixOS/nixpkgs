{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "queueing";
  version = "1.2.8";

  src = fetchurl {
    url = "https://github.com/mmarzolla/queueing/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-kJGURTYig+aImnjXu8ldyqFAJDqV+fpUzR+h6OdvwzM=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/queueing/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
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
