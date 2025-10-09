{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  distutils,
  setuptools,
}:
buildPythonPackage rec {
  pname = "dataclass-csv";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dfurtado";
    repo = "dataclass-csv";
    tag = version;
    hash = "sha256-XDvQrKUtg5ptkF36xGlykhc395pmjBP/19m0EPDyaOM=";
  };

  patches = [
    ./deprecated_dependency.patch
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    distutils
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dataclass_csv" ];

  meta = {
    description = "Map CSV data into dataclasses";
    homepage = "https://github.com/dfurtado/dataclass-csv";
    changelog = "https://github.com/dfurtado/dataclass-csv/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ theobori ];
  };
}
