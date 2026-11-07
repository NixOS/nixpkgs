{
  buildPythonPackage,
  cysignals,
  cython,
  fetchPypi,
  flint,
  iml,
  lib,
  passagemath-environment,
  passagemath-flint,
  passagemath-modules,
  passagemath-setup,
  pkgconfig,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-iml";
  version = "10.8.13";

  pyproject = true;

  src = fetchPypi {
    pname = "passagemath_iml";
    inherit version;
    hash = "sha256-SJQv6RXTQLmmZVvUd1NVVyG89UaPj/p353tJGKHbRDs=";
  };

  build-system = [
    cython
    setuptools
    pkgconfig
    passagemath-setup
  ];

  buildInputs = [
    flint
    iml
  ];

  dependencies = [
    cysignals
    passagemath-environment
    passagemath-flint
    passagemath-modules
  ];

  pythonImportsCheck = [
    "sage.env"
  ];

  meta = {
    description = "passagemath: Linear Algebra with IML";
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}

