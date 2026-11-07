{
  pkgs,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cython,
  pkgconfig,
  passagemath-setup,
  passagemath-environment,
  memory-allocator,
  cysignals,
  passagemath-objects,
  passagemath-categories,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-libecm";
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
    ecm
  ];
  dependencies = [
    memory-allocator
    cysignals
    passagemath-objects
    passagemath-categories
    passagemath-environment
  ];

  src = fetchPypi {
    pname = "passagemath_libecm";
    inherit version;
    hash = "sha256-M5uz4EKiPQy1+hr0MYVZolkqWx0AL2oxapvOb4Q42+Q=";
  };
}
