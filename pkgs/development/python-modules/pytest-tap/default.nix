{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pytestCheckHook
, tappy
}:

buildPythonPackage rec {
  pname = "pytest-tap";
  version = "3.3";

  # Tests not shipped on Pypi.
  src = fetchFromGitHub {
    owner = "python-tap";
    repo = "pytest-tap";
    rev = "v${version}";
    sha256 = "R0RSdKTyJYGq+x0+ut4pJEywTGNgGp/ps36ZaH5dyY4=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    tappy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    "test_unittest_expected_failure"
  ];

  pythonImportsCheck = [
    "pytest_tap"
  ];

  meta = with lib; {
    description = "Test Anything Protocol (TAP) reporting plugin for pytest";
    homepage = "https://github.com/python-tap/pytest-tap";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jtojnar ];
  };
}
