{
  lib,
  buildPythonPackage,
  cysignals,
  cython,
  fetchPypi,
  gmpy2,
  passagemath-environment,
  passagemath-setup,
  pkgconfig,
  pkgs,
  setuptools,
  typing-extensions,
  ...
}:
let
  pname = "passagemath-objects";
  snake_pname = "passagemath_objects";
  version = "10.8.13";
  hash = "sha256-mVGP1gXnEHeiP2B3WmVGh/RdFA79u0aL3iGd/dbRB58=";
in
  buildPythonPackage rec {
    inherit pname version;

    pyproject = true;

    build-system = [
      setuptools
      passagemath-setup
      cython
      pkgconfig
    ];

    buildInputs = with pkgs; [
      gmp
      libmpc
      mpfr
    ];

    dependencies = [
      passagemath-environment
      gmpy2
      cysignals
      typing-extensions
    ];

    src = fetchPypi {
      pname = snake_pname;
      inherit version hash;
    };

    meta = {
      description = "passagemath: Sage objects, elements, parents, categories, coercion, metaclasses";
      longDescription = ''
        `passagemath-objects` provides a fundamental subset of the Sage
        library, including Sage objects, the element/parent framework,
        categories, the coercion system, and the related metaclasses.
      '';
      homepage = "https://passagemath.org";
      sourceProvenance = [ lib.sourceTypes.fromSource ];
      license = lib.licenses.gpl2Plus;
    };
  }
