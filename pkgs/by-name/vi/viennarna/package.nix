{
  lib,
  stdenv,
  fetchurl,
  gsl,
  mpfr,
  perl,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "viennarna";
  version = "2.7.0";

  src = fetchurl {
    url = "https://www.tbi.univie.ac.at/RNA/download/sourcecode/2_7_x/ViennaRNA-${version}.tar.gz";
    hash = "sha256-mpn9aO04CJTe+01eaooocWKScAKM338W8KBdpujHFHM=";
  };

  buildInputs = [
    gsl
    mpfr
    perl
    python3
  ];

  configureFlags = [
    "--with-cluster"
    "--with-kinwalker"
  ];

  meta = {
    description = "Prediction and comparison of RNA secondary structures";
    homepage = "https://www.tbi.univie.ac.at/RNA/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ prusnak ];
    platforms = lib.platforms.unix;
  };
}
