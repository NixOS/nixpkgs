{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestCheckHook
, pexpect
, pytestcov
}:

buildPythonPackage rec {
  pname = "pytest-timeout";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xnsigs0kmpq1za0d4i522sp3f71x5bgpdh3ski0rs74yqy13cr0";
  };

  propagatedBuildInputs = [ pytest ];

  checkInputs = [ pytestCheckHook pexpect pytestcov ];

  disabledTests = [
    "test_suppresses_timeout_when_pdb_is_entered"
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
