{
  buildOctavePackage,
  lib,
  fetchurl,
<<<<<<< HEAD
  statistics,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildOctavePackage rec {
  pname = "financial";
<<<<<<< HEAD
  version = "0.5.4";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-C5BohrTHVMaDrV9GTbp5d0OvXR+szQMjV5hvONFtP7s=";
  };

  requiredOctavePackages = [
    statistics
  ];

=======
  version = "0.5.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0f963yg6pwvrdk5fg7b71ny47gzy48nqxdzj2ngcfrvmb5az4vmf";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    homepage = "https://gnu-octave.github.io/packages/financial/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Monte Carlo simulation, options pricing routines, financial manipulation, plotting functions and additional date manipulation tools";
  };
}
