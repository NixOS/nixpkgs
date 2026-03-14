{
  buildOctavePackage,
  lib,
  fetchurl,
  statistics,
}:

buildOctavePackage rec {
  pname = "financial";
  version = "0.5.4";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-C5BohrTHVMaDrV9GTbp5d0OvXR+szQMjV5hvONFtP7s=";
  };

  requiredOctavePackages = [
    statistics
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/financial/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Monte Carlo simulation, options pricing routines, financial manipulation, plotting functions and additional date manipulation tools";
  };
}
