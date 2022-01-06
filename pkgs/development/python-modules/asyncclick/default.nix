{ lib
, anyio
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, pytestCheckHook
, pythonOlder
, trio
}:

buildPythonPackage rec {
  pname = "asyncclick";
  version = "8.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python-trio";
    repo = pname;
    rev = version;
    sha256 = "sha256-7yTiRGvYhxPPoQyl5loGmQga4pSYRuvekvpJDN3ru18=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    anyio
  ];

  checkInputs = [
    pytestCheckHook
    trio
  ];

  pythonImportsCheck = [
    "click"
  ];

  meta = with lib; {
    description = "Python composable command line utility";
    homepage = "https://github.com/python-trio/asyncclick";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
