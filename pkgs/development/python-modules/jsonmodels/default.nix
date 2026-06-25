{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  python-dateutil,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jsonmodels";
  version = "2.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C6QWm1wCAPVQUolM+g/Nr5L7MqY+eL7pSHnu88lHVa0=";
  };

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jsonmodels" ];

  meta = {
    description = "Makes it easier for you to deal with structures that are common for models";
    homepage = "https://github.com/jazzband/jsonmodels";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}
