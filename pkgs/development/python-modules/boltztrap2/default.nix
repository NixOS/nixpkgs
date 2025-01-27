{
  lib,
  buildPythonPackage,
  fetchPypi,
  spglib,
  numpy,
  scipy,
  matplotlib,
  ase,
  netcdf4,
  pythonOlder,
  cython,
  cmake,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "boltztrap2";
  version = "24.9.4";

  pyproject = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "boltztrap2";
    inherit version;
    hash = "sha256-BfGR7sY0E9r+RXA1fC9uy1GXC+EFV1RKOvMyvGcf+aE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy>=2.0.0" "numpy"
  '';

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    cython
  ];

  dependencies = [
    spglib
    numpy
    scipy
    matplotlib
    ase
    netcdf4
  ];

  # pypi release does no include files for tests
  doCheck = false;

  pythonImportsCheck = [ "BoltzTraP2" ];

  meta = with lib; {
    description = "Band-structure interpolator and transport coefficient calculator";
    mainProgram = "btp2";
    homepage = "http://www.boltztrap.org/";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
