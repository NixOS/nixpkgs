{
  pkgs,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cython,
  pkgconfig,
  passagemath-setup,
  passagemath-environment,
  gmpy2,
  cysignals,
  fpylll,
  memory-allocator,
  scipy,
  passagemath-modules,
  passagemath-flint,
  passagemath-polyhedra,
  passagemath-singular,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-schemes";
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
    gmp
    mpfr
    flint
    libmpc
    ntl
    singular
  ];
  dependencies = [
    gmpy2
    cysignals
    fpylll
    memory-allocator
    scipy
    passagemath-modules
    passagemath-flint
    passagemath-polyhedra
    passagemath-singular
  ];

  src = fetchPypi {
    pname = "passagemath_schemes";
    inherit version;
    hash = "sha256-DVYop+iFnY5RGAMutjgUZ1p1GJrt1UvwzQXidL6gdnk=";
  };
}
