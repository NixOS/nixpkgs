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
  version = "0.12.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pyproject_metadata";
    inherit version;
    hash = "sha256-iAmk32/ggnmzmoiQZpUG7TFY4GF4Vaya/wmPy+dyrkw=";
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
    changelog = "https://github.com/pypa/pyproject-metadata/releases/tag/${version}";
    license = lib.licenses.mit;
  };
}
