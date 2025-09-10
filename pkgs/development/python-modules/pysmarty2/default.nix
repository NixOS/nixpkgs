{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pymodbus,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pysmarty2";
  version = "0.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "martinssipenko";
    repo = "pysmarty2";
    tag = "v${version}";
    hash = "sha256-vDm+ThPHb6O+CoBiRAVCA01O7yQqVLcmVb+Ca2JSljY=";
  };

  build-system = [ setuptools ];

  dependencies = [ pymodbus ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysmarty2" ];

  meta = {
    description = "Python API for Salda Smarty Modbus TCP";
    homepage = "https://github.com/martinssipenko/pysmarty2";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
