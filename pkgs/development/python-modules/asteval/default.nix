{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "asteval";
  version = "1.0.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lmfit";
    repo = "asteval";
    tag = version;
    hash = "sha256-DzLVe8TlWAPQXzai9CJlDAow6UTSmkA/DW3fT30YfZY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov=asteval --cov-report html" ""
  '';

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "asteval" ];

  disabledTests = [
    # AssertionError: 'ImportError' != None
    "test_set_default_nodehandler"
  ];

  meta = with lib; {
    description = "AST evaluator of Python expression using ast module";
    homepage = "https://github.com/lmfit/asteval";
    changelog = "https://github.com/lmfit/asteval/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
