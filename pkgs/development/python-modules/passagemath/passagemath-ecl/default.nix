{
  buildPythonPackage,
  cysignals,
  cython,
  fetchPypi,
  lib,
  passagemath-categories,
  passagemath-environment,
  passagemath-setup,
  pkgconfig,
  pkgs,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-ecl";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    passagemath-setup
    pkgconfig
    cython
  ];
  nativeBuildInputs = with pkgs; [
    ecl
  ];
  buildInputs = with pkgs; [
    ecl
    gmp
    libffi
  ];
  dependencies = [
    cysignals
    passagemath-categories
    passagemath-environment
  ];

  src = fetchPypi {
    pname = "passagemath_ecl";
    inherit version;
    hash = "sha256-BD6+7oPJpChvy6UFVMfMG6wa0ZQDzaIn0cuW9+2ExsU=";
  };

  meta = {
    description = "passagemath: Embeddable Common Lisp";
    homepage = "https://passagemath.org";
    sourceProvenance = "https://github.com/passagemath/passagemath";
    license = lib.licenses.gpl2Plus;
  };
}
