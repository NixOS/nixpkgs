{
  pkgs,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cython,
  pkgconfig,
  passagemath-setup,
  passagemath-environment,
  cysignals,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-palp";
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
    palp
  ];
  dependencies = [
    cysignals
    passagemath-environment
  ];

  src = fetchPypi {
    pname = "passagemath_palp";
    inherit version;
    hash = "sha256-q8wwaS5p/JvwguQo68fK4zr0Tig3soYDv6SEjd2/Ikg=";
  };
}
