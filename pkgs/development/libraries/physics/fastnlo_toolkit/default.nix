{ lib
, stdenv
, fetchurl
, autoreconfHook
, boost
, gfortran
, lhapdf
, ncurses
, python ? null
, swig
, yoda
, zlib
, withPython ? false
}:

stdenv.mkDerivation rec {
  pname = "fastnlo_toolkit";
  version = "2.3.1pre-2411";

  src = fetchurl {
    urls = [
      "https://fastnlo.hepforge.org/code/v23/${pname}-${version}.tar.gz"
      "https://sid.ethz.ch/debian/fastnlo/${pname}-${version}.tar.gz"
    ];
    sha256 = "0fm9k732pmi3prbicj2yaq815nmcjll95fagjqzf542ng3swpqnb";
  };

  nativeBuildInputs = lib.optional withPython autoreconfHook;

  buildInputs = [
    boost
    gfortran
    gfortran.cc.lib
    lhapdf
    yoda
  ] ++ lib.optional withPython python
    ++ lib.optional (withPython && python.isPy3k) ncurses;

  propagatedBuildInputs = [
    zlib
  ] ++ lib.optional withPython swig;

  preConfigure = ''
    substituteInPlace ./fastnlotoolkit/Makefile.in \
      --replace "-fext-numeric-literals" ""
  '';

  configureFlags = [
    "--with-yoda=${yoda}"
  ] ++ lib.optional withPython "--enable-pyext";

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
