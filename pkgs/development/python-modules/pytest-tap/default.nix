{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytest
, tappy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-tap";
  version = "3.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

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
    # Fixed in 4ed0138bf659c348b6dfb8bb701ae1989625d3d8 and hopefully in next release
    "test_unittest_expected_failure"
  ];

  pythonImportsCheck = [
    "pytest_tap"
  ];

  meta = with lib; {
    description = "Test Anything Protocol (TAP) reporting plugin for pytest";
    homepage = "https://github.com/python-tap/pytest-tap";
    changelog = "https://github.com/python-tap/pytest-tap/blob/v${version}/docs/releases.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ cynerd ];
  };
}
