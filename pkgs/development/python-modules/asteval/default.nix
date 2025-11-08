{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "asteval";
  version = "1.0.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "lmfit";
    repo = "asteval";
    tag = version;
    hash = "sha256-c+gVT947IpJC2gn1SWVth0ScOBh34m89dpgR5AikOHk=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "asteval" ];

  disabledTests = [
    # AssertionError: 'ImportError' != None
    "test_set_default_nodehandler"
  ];

  meta = with lib; {
    description = "AST evaluator of Python expression using ast module";
    homepage = "https://github.com/lmfit/asteval";
    changelog = "https://github.com/lmfit/asteval/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
