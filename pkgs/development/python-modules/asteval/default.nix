{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "asteval";
  version = "0.9.28";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "newville";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-J35AqVSFpIsw0XThbLCJjS9NFRFeyYV/YrwdfcOrFhk=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
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
