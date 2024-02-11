{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pytest-metadata
, pytest-xdist
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pytest-json-report";
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "numirias";
    repo = "pytest-json-report";
    rev = "refs/tags/v${version}";
    hash = "sha256-hMB/atDuo7CjwhHFUOxVfgJ7Qp4AA9J428iv7hyQFcs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    pytest-metadata
  ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # pytest-flaky is not available at the moment
    "test_bug_31"
    "test_environment_via_metadata_plugin"
  ];

  pythonImportsCheck = [
    "pytest_jsonreport"
  ];

  meta = with lib; {
    description = "Pytest plugin to report test results as JSON";
    homepage = "https://github.com/numirias/pytest-json-report";
    changelog = "https://github.com/numirias/pytest-json-report/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
