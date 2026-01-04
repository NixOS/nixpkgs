{
  buildOctavePackage,
  lib,
  fetchurl,
  gfortran,
}:

buildOctavePackage rec {
  pname = "optiminterp";
  version = "0.3.7";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-ubh/iOZlWTOYsTA6hJfPOituNBKTn2LbBnx+tmmSEug=";
  };

  nativeBuildInputs = [
    gfortran
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/optiminterp/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Optimal interpolation toolbox for octave";
    longDescription = ''
      An optimal interpolation toolbox for octave. This package provides
      functions to perform a n-dimensional optimal interpolations of
      arbitrarily distributed data points.
    '';
  };
}
