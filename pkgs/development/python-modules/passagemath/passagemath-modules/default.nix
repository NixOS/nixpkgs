{
  lib,
  buildPythonPackage,
  callPackage,
  pkg-config,
  gmp,
  libmpc,
  mpfr,
  gsl,
  fetchPypi,
  setuptools,
  cython,
  passagemath-setup,
  passagemath-environment,
  cysignals,
  numpy,
  passagemath-categories,
  gmpy2,
  jinja2,
  pkgconfig,
  passagemath-flint,
  ...
}:
let
  memory-allocator = callPackage ../downgrades/memory-allocator { };
  mpmath = callPackage ../downgrades/mpmath { };
in
buildPythonPackage rec {
  pname = "passagemath-modules";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    passagemath-setup
    jinja2
    pkgconfig
    cython
    numpy
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gmp
    libmpc
    mpfr
    gsl
  ];

  dependencies = [
    gmpy2
    cysignals
    memory-allocator
    passagemath-categories
    passagemath-environment
    mpmath
  ];

  src = fetchPypi {
    pname = "passagemath_modules";
    inherit version;
    hash = "sha256-EIsWJ3Ej1ubsYmjtAzIMrW3XPtyrJgfI2Day0X1dmQg=";
  };

  meta = {
    description = "passagemath: Vectors, matrices, tensors, vector spaces, affine spaces, modules and algebras, additive groups, quadratic forms, root systems, homology, coding theory, matroids";
    longDescription = ''
      `passagemath-modules` provides a subset of the Sage library for
      vectors, matrices, tensors, modules, algebras, and related structures.
      It includes arbitrary precision real and complex arithmetic, quadratic
      forms, root systems, homology, coding theory, and matroids.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
