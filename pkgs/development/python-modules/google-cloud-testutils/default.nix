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
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-test-utils";
    tag = "v${version}";
    hash = "sha256-WxEFtYiWSl9ZmaduucdVpiCb2SUEVwUdY8jG8GHni7M=";
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
    changelog = "https://github.com/googleapis/python-test-utils/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
