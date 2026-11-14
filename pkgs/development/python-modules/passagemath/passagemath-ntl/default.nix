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
  cysignals,
  passagemath-categories,
  passagemath-modules,
  ...
}:
let
  memory-allocator = callPackage ../downgrades/memory-allocator { };
in
buildPythonPackage rec {
  pname = "passagemath-ntl";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    passagemath-setup
    passagemath-modules
    cython
    pkgconfig
  ];
  buildInputs = with pkgs; [
    gmp
    libmpc
    mpfr
    ntl
    mpfi
    m4ri
  ];
  dependencies = [
    cysignals
    memory-allocator
    passagemath-environment
    passagemath-categories
  ];
  src = fetchPypi {
    pname = "passagemath_ntl";
    inherit version;
    hash = "sha256-d3OOsfFEsuoQbkPNuZnzotYabZX7xnuZ1Bf/LOAnEJQ=";
  };

  meta = {
    description = "passagemath: Computational Number Theory with NTL";
    longDescription = ''
      `passagemath-ntl` provides Sage library modules that depend on NTL,
      including finite fields of characteristic 2, p-adic extension elements,
      and computations of Bernoulli numbers modulo primes.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
