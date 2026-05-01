{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "braintree";
  version = "4.40.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "braintree";
    repo = "braintree_python";
    rev = version;
    hash = "sha256-50UKCtZBnuSMhRoh7HAw6WxiN9iSKY2L+61pA0hmCGY=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "braintree" ];

  enabledTestPaths = [
    "tests/"
    "tests/fixtures"
    "tests/unit"
    "tests/integration/test_credentials_parser.py"
  ];

  meta = {
    description = "Python library for integration with Braintree";
    homepage = "https://github.com/braintree/braintree_python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
