{
  buildPythonPackage,
  callPackage,
  cysignals,
  cython,
  ecm,
  fetchPypi,
  gmp,
  lib,
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

  buildInputs = [
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

  meta = {
    description = "passagemath: Elliptic curve method for integer factorization using GMP-ECM";
    longDescription = ''
      `passagemath-libecm` provides Python and Cython interfaces to GMP-ECM,
      an implementation of the Elliptic Curve Method for integer factorization.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
