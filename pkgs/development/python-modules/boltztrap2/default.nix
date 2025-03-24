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
  version = "25.2.1";

  pyproject = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "boltztrap2";
    inherit version;
    hash = "sha256-vsg3VsN4sea+NFNwTk/5KiT/vwftDYRSAIflK+rwbQs=";
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
