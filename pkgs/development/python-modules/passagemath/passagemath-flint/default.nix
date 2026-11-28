{
  buildPythonPackage,
  cython,
  fetchPypi,
  flint,
  gmp,
  gsl,
  lib,
  libz,
  mpfi,
  mpfr,
  ntl,
  numpy,
  passagemath-categories,
  passagemath-environment,
  passagemath-modules,
  passagemath-ntl,
  passagemath-setup,
  pkgconfig,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-flint";
  version = "10.8.13";

  pyproject = true;

  build-system = [
    setuptools
    cython
    pkgconfig
    passagemath-setup
    passagemath-environment
    passagemath-modules
  ];

  buildInputs = [
    flint
    gmp
    libz
    mpfr
    gsl
    ntl
    mpfi
  ];

  dependencies = [
    numpy
    passagemath-ntl
    passagemath-categories
  ];

  src = fetchPypi {
    pname = "passagemath_flint";
    inherit version;
    hash = "sha256-T0cjq9zrgvKQ/SC5vXMXhwj1t3IeY6e8ZT3Lzw6kEGc=";
  };

  meta = {
    description = "passagemath: Fast computations with MPFI and FLINT";
    longDescription = ''
      `passagemath-flint` provides Cython interfaces to the `MPFI` and `FLINT` libraries.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
