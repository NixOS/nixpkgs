{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestCheckHook
, pexpect
}:

buildPythonPackage rec {
  pname = "pytest-timeout";
  version = "2.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ejl3KRJcbsvaygEDW55SOdTblzUjIK8VWz9d4bpRZdk=";
  };

  buildInputs = [
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pexpect
  ];

  disabledTests = [
    "test_suppresses_timeout_when_pdb_is_entered"
    # Remove until https://github.com/pytest-dev/pytest/pull/7207 or similar
    "test_suppresses_timeout_when_debugger_is_entered"
  ];

  pytestFlagsArray = [
    "-ra"
  ];

  pythonImportsCheck = [
    "pytest_timeout"
  ];

  meta = with lib; {
    description = "Pytest plugin to abort hanging tests";
    homepage = "https://github.com/pytest-dev/pytest-timeout/";
    changelog = "https://github.com/pytest-dev/pytest-timeout/#changelog";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
