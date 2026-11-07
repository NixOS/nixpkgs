{
  buildPythonPackage,
  cysignals,
  cython,
  fetchPypi,
  gmpy2,
  lib,
  memory-allocator,
  passagemath-environment,
  passagemath-glpk,
  passagemath-modules,
  passagemath-ppl,
  passagemath-setup,
  pkgconfig,
  pkgs,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-polyhedra";
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
    libmpc
    mpfr
  ];
  dependencies = [
    cysignals
    gmpy2
    memory-allocator
    passagemath-environment
    passagemath-ppl
    passagemath-modules
    passagemath-glpk
  ];

  src = fetchPypi {
    pname = "passagemath_polyhedra";
    inherit version;
    hash = "sha256-lbpXqhcnE3O/X1ZPjmVPDMY7zeZazgvyG+Xg7vZgGaw=";
  };

  meta = {
    description = "passagemath: Convex polyhedra in arbitrary dimension, mixed integer linear optimization";
    homepage = "https://passagemath.org";
    sourceProvenance = "https://github.com/passagemath/passagemath";
    license = lib.licenses.gpl2Plus;
  };
}
