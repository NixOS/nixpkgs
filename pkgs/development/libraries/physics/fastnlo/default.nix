{ stdenv, fetchurl, boost, fastjet, gfortran, lhapdf, python2, root, yoda, zlib }:

stdenv.mkDerivation rec {
  name = "fastnlo_toolkit-${version}";
  version = "2.3.1pre-2402";

  src = fetchurl {
    url = "http://fastnlo.hepforge.org/code/v23/${name}.tar.gz";
    sha256 = "1h41xnqcz401x3zbs8i2dsb4xlhbv8i5ps0561p6y7gcyridgcbl";
  };

  buildInputs = [ boost fastjet gfortran gfortran.cc.lib lhapdf python2 root yoda ];
  propagatedBuildInputs = [ zlib ];

  preConfigure = ''
    substituteInPlace ./fastnlotoolkit/Makefile.in \
      --replace "-fext-numeric-literals" ""
  '';

  configureFlags = [
    "--with-yoda=${yoda}"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A computer code to create and evaluate fast interpolation tables of pre-computed coefficients in perturbation theory for observables in hadron-induced processes";
    license      = stdenv.lib.licenses.gpl3;
    homepage     = http://fastnlo.hepforge.org;
    platforms    = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
