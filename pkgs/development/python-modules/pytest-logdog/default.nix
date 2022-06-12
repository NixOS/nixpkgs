{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-logdog";
  version = "0.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ods";
    repo = pname;
    rev = version;
    hash = "sha256-Tmoq+KAGzn0MMj29rukDfAc4LSIwC8DoMTuBAppV32I=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];


  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_logdog"
  ];

  meta = with lib; {
    description = "Pytest plugin to test logging";
    homepage = "https://github.com/ods/pytest-logdog";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
