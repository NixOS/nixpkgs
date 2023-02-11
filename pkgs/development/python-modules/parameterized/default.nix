{ lib
, buildPythonPackage
, fetchPypi
, mock
, nose
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "parameterized";
  version = "0.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Qbv/N9YYZDD3f5ANd35btqJJKKHEb7HeaS+LUriDO1w=";
  };

  checkInputs = [
    mock
    nose
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "parameterized/test.py"
  ];

  disabledTests = [
    # Tests seem outdated
    "test_method"
    "test_with_docstring_0_value1"
    "test_with_docstring_1_v_l_"
    "testCamelCaseMethodC"
  ];

  pythonImportsCheck = [
    "parameterized"
  ];

  meta = with lib; {
    description = "Parameterized testing with any Python test framework";
    homepage = "https://github.com/wolever/parameterized";
    changelog = "https://github.com/wolever/parameterized/blob/v${version}/CHANGELOG.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
