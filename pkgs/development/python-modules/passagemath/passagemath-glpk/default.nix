{
  buildPythonPackage,
  callPackage,
  fetchPypi,
  glpk,
  gmp,
  libmpc,
  mpfr,
  lib,
  libz,
  passagemath-setup,
  setuptools,
  passagemath-environment,
  cython,
  pkgconfig,
  passagemath-categories,
  passagemath-objects,
  cysignals,
  ...
}:
let
  memory-allocator = callPackage ../downgrades/memory-allocator { };
in
buildPythonPackage rec {
  pname = "passagemath-glpk";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    pkgconfig
    passagemath-setup
    passagemath-categories
    passagemath-environment
    cython
  ];

  buildInputs =[
    glpk
    gmp
    libmpc
    mpfr
    libz
  ];

  dependencies = [
    passagemath-objects
    memory-allocator
    cysignals
  ];

  src = fetchPypi {
    pname = "passagemath_glpk";
    inherit version;
    hash = "sha256-7VNjIRAALpu0SuuUh+taNzOxxJp1rM2SndGykSm6fDY=";
  };

  meta = {
    description = "passagemath: Linear and mixed integer linear optimization backend using GLPK";
    longDescription = ''
      `passagemath-glpk` provides a backend for linear and mixed integer linear optimization backend using GLPK.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
