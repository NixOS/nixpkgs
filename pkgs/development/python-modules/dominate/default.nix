{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dominate";
  version = "2.9.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VYKEaH2biq4ZBOPWBRrRMt1KjAz1UbN+pOfkKjHRncQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dominate" ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.13") [
    # Tests are failing, https://github.com/Knio/dominate/issues/213
    "tests/test_svg.py"
  ];

  meta = with lib; {
    description = "Library for creating and manipulating HTML documents using an elegant DOM API";
    homepage = "https://github.com/Knio/dominate/";
    changelog = "https://github.com/Knio/dominate/releases/tag/${version}";
    license = licenses.lgpl3Plus;
    maintainers = [ ];
  };
}
