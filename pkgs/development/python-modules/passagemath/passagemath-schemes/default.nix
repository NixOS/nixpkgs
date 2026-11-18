{
  lib,
  pkgs,
  buildPythonPackage,
  callPackage,
  fetchPypi,
  setuptools,
  cython,
  pkgconfig,
  passagemath-setup,
  passagemath-environment,
  gmpy2,
  cysignals,
  fpylll,
  scipy,
  passagemath-modules,
  passagemath-flint,
  passagemath-polyhedra,
  passagemath-singular,
  ...
}:
let
  memory-allocator = callPackage ../downgrades/memory-allocator { };
in
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

  meta = {
    description = "passagemath: Schemes, varieties, elliptic curves, algebraic Riemann surfaces, modular forms, arithmetic dynamics";
    longDescription = ''
      `passagemath-schemes` provides Sage library modules for schemes,
      algebraic curves, elliptic and hyperelliptic curves, modular forms,
      modular symbols, modular abelian varieties, and arithmetic dynamics.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
