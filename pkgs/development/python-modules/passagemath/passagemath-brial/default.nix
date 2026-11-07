{
  pkgs,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cython,
  pkgconfig,
  passagemath-setup,
  cysignals,
  passagemath-categories,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-brial";
  version = "10.8.13";

  pyproject = true;

  build-system = [
    setuptools
    pkgconfig
    cython
    passagemath-setup
  ];

  buildInputs = with pkgs; [
    gmp
    gd
    boost
    m4ri
    libpng
    brial
  ];

  dependencies = [
    cysignals
    passagemath-categories
  ];

  src = fetchPypi {
    pname = "passagemath_brial";
    inherit version;
    hash = "sha256-HGCdG76KdKR/Us+Nd6pN5rD6VK1gS9OquaKsFniBjQY=";
  };
}
