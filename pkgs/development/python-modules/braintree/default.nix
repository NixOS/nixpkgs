{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "braintree";
  version = "4.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = "braintree_python";
    rev = version;
    hash = "sha256-qeqQX+qyy78sLe+46CA4D6VAxNHUVahS4LMYdGDzc2k=";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "braintree"
  ];

  disabledTestPaths = [
    # Don't test integrations
    "tests/integration"
  ];

  meta = with lib; {
    description = "Python library for integration with Braintree";
    homepage = "https://github.com/braintree/braintree_python";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
