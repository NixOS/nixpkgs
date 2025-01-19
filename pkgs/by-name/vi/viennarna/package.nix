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
  version = "2.5.1";

  src = fetchurl {
    url = "https://www.tbi.univie.ac.at/RNA/download/sourcecode/2_5_x/ViennaRNA-${version}.tar.gz";
    sha256 = "sha256-BUAEN88VWV4QsaJd9snEiFbzVhMPnR44D6iGa20n9Fc=";
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
