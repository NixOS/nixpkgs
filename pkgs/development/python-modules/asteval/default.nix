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
  version = "0.9.32";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lmfit";
    repo = "asteval";
    rev = "refs/tags/${version}";
    hash = "sha256-3eML5lEKEUlp3Fwdgvk31an83x8no5ichskKvzYJDsE=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail " --cov=asteval --cov-report xml" ""
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
