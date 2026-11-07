{
  buildPythonPackage,
  callPackage,
  cysignals,
  cython,
  fetchPypi,
  highs,
  lib,
  libz,
  passagemath-categories,
  passagemath-environment,
  passagemath-objects,
  passagemath-setup,
  pkgconfig,
  setuptools,
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

  buildInputs = [
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

  meta = {
    description = "passagemath: Linear and mixed integer linear optimization backend using HiGHS";
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
