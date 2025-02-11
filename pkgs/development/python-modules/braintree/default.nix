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
  version = "4.29.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "braintree";
    repo = "braintree_python";
    rev = version;
    hash = "sha256-5MF8W2zUVvNiOnmszgJkMDmeYLZ6ppFHqmH6dmlCzQY=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "braintree" ];

  pytestFlagsArray = [
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
