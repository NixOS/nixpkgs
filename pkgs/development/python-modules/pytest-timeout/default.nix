{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestCheckHook
, pexpect
, pytest-cov
}:

buildPythonPackage rec {
  pname = "pytest-timeout";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xnsigs0kmpq1za0d4i522sp3f71x5bgpdh3ski0rs74yqy13cr0";
  };

  buildInputs = [ pytest ];

  checkInputs = [ pytestCheckHook pexpect pytest-cov ];

  disabledTests = [
    "test_suppresses_timeout_when_pdb_is_entered"
    # Remove until https://github.com/pytest-dev/pytest/pull/7207 or similar
    "test_suppresses_timeout_when_debugger_is_entered"
  ];
  pytestFlagsArray = [
    "-ra"
  ];

  meta = with lib; {
    description = "py.test plugin to abort hanging tests";
    homepage = "https://github.com/pytest-dev/pytest-timeout/";
    changelog = "https://github.com/pytest-dev/pytest-timeout/#changelog";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu costrouc ];
  };
}
