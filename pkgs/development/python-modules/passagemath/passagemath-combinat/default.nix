{
  buildPythonPackage,
  cysignals,
  cython,
  fetchPypi,
  gmpy2,
  lib,
  memory-allocator,
  passagemath-categories,
  passagemath-environment,
  passagemath-setup,
  pkgconfig,
  pkgs,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-combinat";
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
    symmetrica
  ];
  dependencies = [
    gmpy2
    cysignals
    memory-allocator
    passagemath-categories
    passagemath-environment
  ];

  src = fetchPypi {
    pname = "passagemath_combinat";
    inherit version;
    hash = "sha256-NL041IFFaWhfnXd47xHGwULzXJx1Il1WMCZAc6qqDFE=";
  };
  
  meta = {
    description = "passagemath: Algebraic combinatorics, combinatorial representation theory";
    homepage = "https://passagemath.org";
    sourceProvenance = "https://github.com/passagemath/passagemath";
    license = lib.licenses.gpl2Plus;
  };
}
