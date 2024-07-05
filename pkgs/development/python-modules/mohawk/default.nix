{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  mock,
  pynose,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "mohawk";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0qDjqxCiCcx56V4o8t1UvUpz/RmY/+J7e6D5Yra+lyM=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  pythonImportsCheck = [ "mohawk" ];

  nativeCheckInputs = [
    mock
    pynose
    pytestCheckHook
  ];

  pytestFlagsArray = [ "mohawk/tests.py" ];

  meta = {
    description = "Python library for Hawk HTTP authorization";
    homepage = "https://github.com/kumar303/mohawk";
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
}
