{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  google-auth,
  packaging,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-testutils";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-test-utils";
    tag = "v${version}";
    hash = "sha256-g7XwDQp4c+duKfUWqhnI8T001fu6cM22oWLriyCZZag=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    google-auth
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "test_utils" ];

  meta = {
    description = "System test utilities for google-cloud-python";
    mainProgram = "lower-bound-checker";
    homepage = "https://github.com/googleapis/python-test-utils";
    changelog = "https://github.com/googleapis/python-test-utils/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
