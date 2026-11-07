{
  buildPythonPackage,
  cysignals,
  cython,
  fetchPypi,
  gmpy2,
  passagemath-environment,
  passagemath-setup,
  pkgconfig,
  pkgs,
  setuptools,
  typing-extensions,
  ...
}:
let
  pname = "passagemath-objects";
  snake_pname = "passagemath_objects";
  version = "10.8.13";
  hash = "sha256-mVGP1gXnEHeiP2B3WmVGh/RdFA79u0aL3iGd/dbRB58=";
in
  buildPythonPackage rec {
    inherit pname version;

    pyproject = true;

    build-system = [
      setuptools
      passagemath-setup
      cython
      pkgconfig
    ];

    buildInputs = with pkgs; [
      gmp
      libmpc
      mpfr
    ];

    dependencies = [
      passagemath-environment
      gmpy2
      cysignals
      typing-extensions
    ];

    src = fetchPypi {
      pname = snake_pname;
      inherit version hash;
    };
  }
