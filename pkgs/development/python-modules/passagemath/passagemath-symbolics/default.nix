{
  buildPythonPackage,
  callPackage,
  cysignals,
  cython,
  fetchPypi,
  gmpy2,
  lib,
  numpy,
  passagemath-categories,
  passagemath-environment,
  passagemath-flint,
  passagemath-gsl,
  passagemath-modules,
  passagemath-ntl,
  passagemath-setup,
  pkgconfig,
  pkgs,
  setuptools,
  sympy,
  ...
}:
let
  mpmath = callPackage ../downgrades/mpmath { };
in
buildPythonPackage rec {
  pname = "passagemath-symbolics";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    cython
    pkgconfig
    passagemath-setup
    passagemath-environment
  ];
  buildInputs = with pkgs; [
    gsl
    flint
    ntl
    gmp
    mpfr
    singular
  ];
  dependencies = [
    gmpy2
    cysignals
    numpy
    (sympy.override { inherit mpmath; })
    mpmath

    passagemath-categories
    passagemath-environment
    passagemath-ntl
    passagemath-gsl
    passagemath-flint
    passagemath-modules
  ];

  src = fetchPypi {
    pname = "passagemath_symbolics";
    inherit version;
    hash = "sha256-pXlNwYClyz5M6IPpKFUPaaMIU3eSWRmb//LmDoCRNdY=";
  };

  meta = {
    description = "passagemath: Symbolic calculus";
    longDescription = ''
      `passagemath-symbolics` provides Sage library modules for symbolic
      calculus using Pynac, arithmetic and special functions, asymptotic
      expansions, manifolds, and hyperbolic geometry.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
