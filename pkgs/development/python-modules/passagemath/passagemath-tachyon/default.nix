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
  passagemath-objects,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-tachyon";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    pkgconfig
    passagemath-setup
    cython
  ];
  buildInputs = with pkgs; [
    tachyon
    libz
  ];
  dependencies = [
    cysignals
    passagemath-environment
    passagemath-objects
  ];

  src = fetchPypi {
    pname = "passagemath_tachyon";
    inherit version;
    hash = "sha256-fVZr748zUWB1UPSuiO7Dn70EJl7mXQpmdwsYyO6ypvA=";
  };
}
