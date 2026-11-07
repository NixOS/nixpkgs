{
  buildPythonPackage,
  callPackage,
  cython,
  fetchPypi,
  gmp,
  jinja2,
  libmpc,
  mpfr,
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
  pname = "passagemath-categories";
  version = "10.8.13";

  pyproject = true;

  build-system = [
    setuptools
    passagemath-setup
    jinja2
    cython
    pkgconfig
  ];

  buildInputs = [
    gmp
    libmpc
    mpfr
  ];

  dependencies = [
    passagemath-objects
    memory-allocator
  ];
  src = fetchPypi {
    pname = "passagemath_categories";
    inherit version;
    hash = "sha256-8Ni+F4oE2EkgcQIxMIkU5uPZrv4lnPz4wU24qXidPlc=";
  };
}
