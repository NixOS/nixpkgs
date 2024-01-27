{ lib
, buildPythonPackage
, decorator
, fetchFromGitHub
, ply
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bc-jsonpath-ng";
  version = "1.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bridgecrewio";
    repo = "jsonpath-ng";
    rev = "refs/tags/${version}";
    hash = "sha256-FWP4tzlacAWVXG3YnPwl5MKc12geaCxZ2xyKx9PSarU=";
  };

  propagatedBuildInputs = [
    decorator
    ply
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Exclude tests that require oslotest
    "tests/test_jsonpath_rw_ext.py"
  ];

  pythonImportsCheck = [
    "bc_jsonpath_ng"
  ];

  meta = with lib; {
    description = "JSONPath implementation for Python";
    homepage = "https://github.com/bridgecrewio/jsonpath-ng";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
