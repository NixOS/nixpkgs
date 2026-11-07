{
  pkgs,
  buildPythonPackage,
  callPackage,
  fetchPypi,
  setuptools,
  cython,
  pkgconfig,
  passagemath-setup,
  passagemath-environment,
  cysignals,
  passagemath-objects,
  passagemath-categories,
  ...
}:
let
  memory-allocator = callPackage ../downgrades/memory-allocator { };
in
buildPythonPackage rec {
  pname = "passagemath-highs";
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
    highs
    libz
  ];
  dependencies = [
    passagemath-objects
    memory-allocator
    cysignals
  ];

  src = fetchPypi {
    pname = "passagemath_highs";
    inherit version;
    hash = "sha256-qhRPvx7g2q+w7KwKqL2Y2GhCHqOtgV2fj3qWHBpp3h8=";
  };
}
