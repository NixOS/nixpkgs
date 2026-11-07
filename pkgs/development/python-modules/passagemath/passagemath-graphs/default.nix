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
  memory-allocator,
  cysignals,
  passagemath-categories,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-graphs";
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
    libmpc
    boost
  ];
  dependencies = [
    gmpy2
    memory-allocator
    cysignals
    passagemath-environment
    passagemath-categories
  ];

  src = fetchPypi {
    pname = "passagemath_graphs";
    inherit version;
    hash = "sha256-unnjdZnN+Yuml26WBcNLfHmbXXDGROGAyMqmkbxsRKE=";
  };
}
