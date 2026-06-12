{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "asteval";
  version = "1.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lmfit";
    repo = "asteval";
    tag = version;
    hash = "sha256-TJGKQA4jI6aRcwUbFH2t1pFs0XdN3MVSEfGovnzI2/Q=";
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

  meta = {
    description = "AST evaluator of Python expression using ast module";
    homepage = "https://github.com/lmfit/asteval";
    changelog = "https://github.com/lmfit/asteval/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
