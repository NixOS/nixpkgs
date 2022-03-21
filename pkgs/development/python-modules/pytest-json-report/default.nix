{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pytest-metadata
, pytest-xdist
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-json-report";
  version = "1.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "numirias";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hMB/atDuo7CjwhHFUOxVfgJ7Qp4AA9J428iv7hyQFcs=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    pytest-metadata
  ];

  checkInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # pytest-flaky is not available at the moment
    "test_bug_31"
  ];

  pythonImportsCheck = [
    "pytest_jsonreport"
  ];

  meta = with lib; {
    description = "Pytest plugin to report test results as JSON";
    homepage = "https://github.com/numirias/pytest-json-report";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
