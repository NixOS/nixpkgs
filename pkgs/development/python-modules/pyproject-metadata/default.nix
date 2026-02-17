{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  packaging,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyproject-metadata";
  version = "0.9.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pyproject_metadata";
    inherit version;
    hash = "sha256-uLIlPdG3Bit4z5SaEV8Cun+kEUqr5j+hBSjp4alUqBY=";
  };

  build-system = [ flit-core ];

  dependencies = [ packaging ];

  nativeCheckInputs = [ pytestCheckHook ];

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
