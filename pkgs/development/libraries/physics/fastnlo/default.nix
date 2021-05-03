{ lib
, stdenv
, fetchurl
, boost
, fastjet
, gfortran
, lhapdf
, python2
, root
, yoda
, zlib
}:

stdenv.mkDerivation rec {
  pname = "fastnlo_toolkit";
  version = "2.3.1pre-2402";

  src = fetchurl {
    url = "https://fastnlo.hepforge.org/code/v23/${pname}-${version}.tar.gz";
    sha256 = "1h41xnqcz401x3zbs8i2dsb4xlhbv8i5ps0561p6y7gcyridgcbl";
  };

  buildInputs = [
    boost
    fastjet
    gfortran
    gfortran.cc.lib
    lhapdf
    python2
    root
    yoda
  ];
  propagatedBuildInputs = [
    zlib
  ];

  preConfigure = ''
    substituteInPlace ./fastnlotoolkit/Makefile.in \
      --replace "-fext-numeric-literals" ""
  '';

  configureFlags = [
    "--with-yoda=${yoda}"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://fastnlo.hepforge.org";
    description = "Fast pQCD calculations for hadron-induced processes";
    longDescription = ''
      The fastNLO project provides computer code to create and evaluate fast
      interpolation tables of pre-computed coefficients in perturbation theory
      for observables in hadron-induced processes.

      This allows fast theory predictions of these observables for arbitrary
      parton distribution functions (of regular shape), renormalization or
      factorization scale choices, and/or values of alpha_s(Mz) as e.g. needed
      in PDF fits or in systematic studies. Very time consuming complete
      recalculations are thus avoided.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ veprbl ];
    platforms = platforms.unix;
  };
}
