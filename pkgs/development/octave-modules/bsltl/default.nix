{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "bsltl";
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    hash = "sha256-S7eueN7MDX9xu1U7oScKO2nvqr7QCnDGasUVf8jwGUU=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/bsltl/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Free collection of OCTAVE/MATLAB routines for working with the biospeckle laser technique";
  };
}
