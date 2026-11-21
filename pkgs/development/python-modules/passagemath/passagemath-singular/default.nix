{
  buildPythonPackage,
  callPackage,
  cysignals,
  cython,
  fetchPypi,
  lib,
  passagemath-categories,
  passagemath-environment,
  passagemath-flint,
  passagemath-modules,
  passagemath-pari,
  passagemath-setup,
  pexpect,
  pkgconfig,
  pkgs,
  setuptools,
  singular,
  ...
}:
let
  memory-allocator = callPackage ../downgrades/memory-allocator { };
in
buildPythonPackage rec {
  pname = "passagemath-singular";
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
    libmpc
    mpfr
    singular
    givaro
    flint
    gsl
    ntl
  ];

  dependencies = [
    passagemath-pari
    cysignals
    memory-allocator
    pexpect
    passagemath-environment
    passagemath-categories
    passagemath-modules
    passagemath-flint
  ];

  src = fetchPypi {
    pname = "passagemath_singular";
    inherit version;
    hash = "sha256-Vwb7Pc7qF5ikZ3L5BiEmlX2JS3cPzjQmaYCohasCoQs=";
  };

  meta = {
    description = "passagemath: Computer algebra, algebraic geometry, singularity theory with Singular";
    longDescription = ''
      `passagemath-singular` provides Cython and Pexpect interfaces to
      Singular, the computer algebra system for polynomial computations with
      an emphasis on commutative and non-commutative algebra, algebraic
      geometry, and singularity theory. It also provides Sage library modules
      that depend on Singular.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
