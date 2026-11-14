{
  pkgs,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cython,
  pkgconfig,
  passagemath-setup,
  cysignals,
  passagemath-categories,
  lib,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-brial";
  version = "10.8.13";

  pyproject = true;

  build-system = [
    setuptools
    pkgconfig
    cython
    passagemath-setup
  ];

  buildInputs = with pkgs; [
    gmp
    gd
    boost
    m4ri
    libpng
    brial
  ];

  dependencies = [
    cysignals
    passagemath-categories
  ];

  src = fetchPypi {
    pname = "passagemath_brial";
    inherit version;
    hash = "sha256-HGCdG76KdKR/Us+Nd6pN5rD6VK1gS9OquaKsFniBjQY=";
  };

  meta = {
    description = "passagemath: Boolean Ring Algebra with BRiAl";
    longDescription = ''
     `passagemath-brial` provides a Boolean Ring Algebra implementation using binary decision diagrams, implemented by the BRiAl library, the successor to PolyBoRi.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
