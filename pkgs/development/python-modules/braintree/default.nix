{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "braintree";
  version = "4.43.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "braintree";
    repo = "braintree_python";
    tag = finalAttrs.version;
    hash = "sha256-4qLi6MplXaIT8+Us3Yb9fTph74XntagBNzyS//4K5Fk=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "braintree" ];

  # Most integration tests require a running Braintree gateway.
  enabledTestPaths = [
    "tests/unit"
    "tests/integration/test_credentials_parser.py"
  ];

  meta = {
    description = "Python library for integration with Braintree";
    homepage = "https://github.com/braintree/braintree_python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
