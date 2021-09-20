{ lib
, stdenv
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

  disabledTests = lib.optionals (stdenv.isDarwin) [
    # Calls pytest and expects "Timeout" in stdout, but it's not in there
    "test_cov"
    "test_fix_setup"
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
