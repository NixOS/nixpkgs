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
<<<<<<< HEAD
  version = "4.41.0";
=======
  version = "4.40.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "braintree";
    repo = "braintree_python";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-5rTYRzlx/XueL6vF0/kM73bgN/QjvM55ZSLIWNI8YiQ=";
=======
    hash = "sha256-50UKCtZBnuSMhRoh7HAw6WxiN9iSKY2L+61pA0hmCGY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
