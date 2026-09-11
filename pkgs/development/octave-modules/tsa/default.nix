{
  buildOctavePackage,
  lib,
  fetchurl,
  nan, # > 3.0.0
}:

buildOctavePackage rec {
  pname = "tsa";
  version = "4.6.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    hash = "sha256-VPO84z3UOf6mDn02JSwE1sazE6Yy3mziBPYe1s/Bfd0=";
  };

  requiredOctavePackages = [
    nan
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/tsa/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Stochastic concepts and maximum entropy methods for time series analysis";
  };
}
