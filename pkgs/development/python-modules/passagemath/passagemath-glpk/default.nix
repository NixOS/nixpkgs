{
  buildPythonPackage,
  fetchPypi,
  passagemath-setup,
  setuptools,
  passagemath-environment,
  cython,
  pkgconfig,
  passagemath-categories,
  pkgs,
  passagemath-objects,
  memory-allocator,
  cysignals,
  ...
}:
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

  buildInputs = with pkgs; [
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
}
