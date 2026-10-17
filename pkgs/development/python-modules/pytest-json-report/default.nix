{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  pytest-metadata,
  pytest-xdist,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-json-report";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "numirias";
    repo = "pytest-json-report";
    tag = "v${version}";
    hash = "sha256-hMB/atDuo7CjwhHFUOxVfgJ7Qp4AA9J428iv7hyQFcs=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ pytest-metadata ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # pytest-flaky is not available at the moment
    "test_bug_31"
    "test_environment_via_metadata_plugin"
    # AssertionError
    "test_report_collectors"
    "test_report_crash_and_traceback"
  ];

  pythonImportsCheck = [ "pytest_jsonreport" ];

  meta = {
    description = "Pytest plugin to report test results as JSON";
    homepage = "https://github.com/numirias/pytest-json-report";
    changelog = "https://github.com/numirias/pytest-json-report/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
