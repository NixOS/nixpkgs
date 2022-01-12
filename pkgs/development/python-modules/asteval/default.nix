{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "asteval";
  version = "0.9.25";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "newville";
    repo = pname;
    rev = version;
    sha256 = "sha256-Jy+4NifItCGI1Jj25VakwoJcrpZw0Ng4cArf2M31WGs=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "asteval" ];

  meta = with lib; {
    description = "AST evaluator of Python expression using ast module";
    homepage = "https://github.com/newville/asteval";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
