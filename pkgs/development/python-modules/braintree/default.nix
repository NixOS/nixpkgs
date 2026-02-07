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
  version = "4.42.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "braintree";
    repo = "braintree_python";
    rev = version;
    hash = "sha256-cpQjf/5Exfpb/NY9offI8U8ny2pKHqHW2PGfo8STE9w=";
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
