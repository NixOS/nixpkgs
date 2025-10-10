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
  version = "4.38.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "braintree";
    repo = "braintree_python";
    rev = version;
    hash = "sha256-cAzqHMkEWaLXHbPUnkyFF5UD43rPk6txRSB2n9NJLTE=";
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
