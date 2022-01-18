{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pytest-metadata
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-json-report";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "numirias";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OS9ASUp9iJ12Ovr931RQU/DHEAXqbgcRMCBP4h+GAhk=";
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
