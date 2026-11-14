{
  buildPythonPackage,
  callPackage,
  cython,
  fetchPypi,
  gmp,
  jinja2,
  lib,
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

  meta = {
    description = "passagemath: Sage categories, basic rings, polynomials, functions";
    longDescription = ''
      `passagemath-categories` provides a small subset of the modules of the Sage library ("sagelib", `passagemath-standard`) building on top of `passagemath-objects` (providing Sage objects, the element/parent framework, categories, the coercion system and the related metaclasses), making various additional categories available without introducing dependencies on additional mathematical libraries.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
