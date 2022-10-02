{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "asteval";
  version = "0.9.27";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "newville";
    repo = pname;
    rev = version;
    hash = "sha256-FxWs4l9bqZoqdyhpVRys8Mo9Wdtn1fm5XonisPscWEs=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov=asteval --cov-report xml" ""
  '';

  pythonImportsCheck = [
    "asteval"
  ];

  meta = with lib; {
    description = "AST evaluator of Python expression using ast module";
    homepage = "https://github.com/newville/asteval";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
