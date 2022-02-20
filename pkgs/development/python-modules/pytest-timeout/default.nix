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
  version = "2.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e6f98b54dafde8d70e4088467ff621260b641eb64895c4195b6e5c8f45638112";
  };

  buildInputs = [
    pytest
  ];

  checkInputs = [
    pytestCheckHook
    pexpect
    pytest-cov
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
    maintainers = with maintainers; [ makefu costrouc ];
  };
}
