{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  packaging,
  pytestCheckHook,
  pythonOlder,
  tomli,
}:

buildPythonPackage rec {
  pname = "pyproject-metadata";
  version = "0.10.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pyproject_metadata";
    inherit version;
    hash = "sha256-f1vQ7zmLYBaVVssX6iYdcVyvf4VhI4FR9RsjBQhLqNQ=";
  };

  build-system = [ flit-core ];

  dependencies = [ packaging ];

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  # Many broken tests, and missing test files
  doCheck = false;

  pythonImportsCheck = [ "pyproject_metadata" ];

  meta = {
    description = "PEP 621 metadata parsing";
    homepage = "https://github.com/FFY00/python-pyproject-metadata";
    changelog = "https://github.com/FFY00/python-pyproject-metadata/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
  };
}
