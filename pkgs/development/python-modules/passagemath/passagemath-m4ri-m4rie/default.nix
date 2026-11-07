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
  cysignals,
  memory-allocator,
  passagemath-modules,
  numpy,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-m4ri-m4rie";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    passagemath-setup
    cython
    numpy
    pkgconfig
  ];

  buildInputs = with pkgs; [
    m4ri
    m4rie
    gmp
    gd
    libpng
  ];

  dependencies = [
    cysignals
    memory-allocator
    passagemath-environment
    passagemath-categories
    passagemath-modules
  ];

  src = fetchPypi {
    pname = "passagemath_m4ri_m4rie";
    inherit version;
    hash = "sha256-mgm5XXt+cBkkccXLbYi3/fFKOPZih2fwDkBoHdUU5SE=";
  };
}
