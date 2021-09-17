{ lib
, stdenv
, fetchFromGitLab
, autoreconfHook
, boost
, gfortran
, lhapdf
, ncurses
, perl
, python ? null
, swig
, yoda
, zlib
, withPython ? false
}:

let
  tag = "2823";
in

stdenv.mkDerivation rec {
  pname = "fastnlo_toolkit";
  version = "2.5.0pre-${tag}";

  src = fetchFromGitLab {
    domain = "gitlab.etp.kit.edu";
    owner = "qcd-public";
    repo = "fastNLO";
    rev = tag;
    hash = "sha256-FEKnEnK90tT4BJJ6MLva9lCl3aYzO1YGdx/8Ol2vM7M=";
  } + /v2.5/toolkit;

  postPatch = ''
    # remove duplicate macro, to fix for autoconf 2.70
    sed -e '0,/AC_CONFIG_MACRO_DIR\([m4]\)/{/AC_CONFIG_MACRO_DIR/d}' -i configure.ac
  '';

  nativeBuildInputs = [ autoreconfHook ];

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

  doCheck = true;
  checkInputs = [
    perl
    lhapdf.pdf_sets.CT10nlo
  ];
  preCheck = ''
    patchShebangs --build check
  '';
  enableParallelChecking = false;

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
    broken = stdenv.isAarch64; # failing test "fnlo-tk-stattest.pl"
  };
}
