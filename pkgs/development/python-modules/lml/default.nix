{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lml";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jdWvtDZ6WT0c2yFEoFh0zZk49SZr67DJ4UEyAEI8DXQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  # Tests broken.
  doCheck = false;

  meta = {
    description = "Plugin management system for Python";
    homepage = "http://lml.readthedocs.io/";
    changelog = "https://github.com/python-lml/lml/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
