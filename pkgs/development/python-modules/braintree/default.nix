{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "braintree";
  version = "4.29.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "braintree";
    repo = "braintree_python";
    rev = version;
    hash = "sha256-5MF8W2zUVvNiOnmszgJkMDmeYLZ6ppFHqmH6dmlCzQY=";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "braintree" ];

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
