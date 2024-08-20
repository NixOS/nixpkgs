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
}:

buildPythonPackage rec {
  pname = "boltztrap2";
  version = "24.1.1";

  pyproject = true;
  build-system = [ setuptools ];

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "BoltzTraP2";
    inherit version;
    hash = "sha256-kgv4lPBxcBmRKihaTwPRz8bHTWAWUOGZADtJUb3y+C4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "USE_CYTHON = False" "USE_CYTHON = True"
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
