{ lib
, buildPythonPackage
, fetchPypi
, pyflakes
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "autoflake";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YaNTASz/arlMoGKCPR+y9pLErNpRx2/4Oo13kV+6Ueo=";
  };

  propagatedBuildInputs = [
    pyflakes
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "autoflake"
  ];

  disabledTests = [
    # AssertionError: True is not false
    "test_is_literal_or_name"
  ];

  meta = with lib; {
    description = "Tool to remove unused imports and unused variables";
    homepage = "https://github.com/myint/autoflake";
    license = licenses.mit;
    maintainers = with maintainers; [ yuriaisaka ];
  };
}
