{
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cython,
  pkgs,
  cysignals,
  gmpy2,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-ppl";
  version = "0.8.10.3";

  pyproject = true;
  build-system = [
    setuptools
    cython
  ];

  buildInputs = with pkgs; [
    libmpc
    mpfr
    gmp
    ppl
  ];

  dependencies = [
    cysignals
    gmpy2
  ];

  src = fetchPypi {
    pname = "passagemath_ppl";
    inherit version;
    hash = "sha256-YuJKEt7o+PzugLuCMcllLhfT8tcQwKKBXSaosHEWLqM=";
  };
}
