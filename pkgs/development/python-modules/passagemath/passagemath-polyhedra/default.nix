{
  buildPythonPackage,
  callPackage,
  cysignals,
  cython,
  fetchPypi,
  gmpy2,
  lib,
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
let
  memory-allocator = callPackage ../downgrades/memory-allocator { };
in
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
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
