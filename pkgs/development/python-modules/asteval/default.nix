{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "asteval";
  version = "0.9.30";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "newville";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-vKPMA8yiTNQPYehDVo6mleOv82ZNxHgi8P/HIOZb9/o=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov=asteval --cov-report xml" ""
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "asteval"
  ];

  disabledTests = [
    # AssertionError: 'ImportError' != None
    "test_set_default_nodehandler"
  ];

  meta = with lib; {
    description = "AST evaluator of Python expression using ast module";
    homepage = "https://github.com/newville/asteval";
    changelog = "https://github.com/newville/asteval/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
