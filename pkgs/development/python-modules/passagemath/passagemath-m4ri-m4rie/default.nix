{
  lib,
  buildPythonPackage,
  callPackage,
  fetchPypi,
  passagemath-setup,
  setuptools,
  passagemath-environment,
  cython,
  pkgconfig,
  passagemath-categories,
  pkgs,
  cysignals,
  passagemath-modules,
  numpy,
  ...
}:
let
  memory-allocator = callPackage ../downgrades/memory-allocator { };
in
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

  meta = {
    description = "passagemath: Linear Algebra with m4ri and m4rie";
    longDescription = ''
      `passagemath-m4ri-m4rie` provides dense matrices over GF(2) using
      M4RI, dense matrices over GF(2^e) using M4RIE, and vectors over GF(2).
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
