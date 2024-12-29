{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  packaging,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  tomli,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyproject-metadata";
  version = "0.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pyproject_metadata";
    inherit version;
    hash = "sha256-N21aAHZKwpRApUV5+I5mt9nLfmKdNcNaHHJIv+vJtFU=";
  };

  build-system = [ flit-core ];

  dependencies = [ packaging ];

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  # Many broken tests, and missing test files
  doCheck = false;

  pythonImportsCheck = [ "pyproject_metadata" ];

  meta = with lib; {
    description = "PEP 621 metadata parsing";
    homepage = "https://github.com/FFY00/python-pyproject-metadata";
    changelog = "https://github.com/FFY00/python-pyproject-metadata/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
  };
}
