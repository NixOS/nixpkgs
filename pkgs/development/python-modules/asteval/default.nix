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
  version = "1.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lmfit";
    repo = "asteval";
    tag = version;
    hash = "sha256-qENmfqWaKhNKMTTYg2QrhL1eqhda8dUOP8b0Wcq4Ats=";
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
