{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  google-api-core,
  google-cloud-logging,
  proto-plus,
  protobuf,

  # testing
  google-cloud-testutils,
  mock,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "google-cloud-error-reporting";
  version = "1.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-error-reporting";
    tag = "v${version}";
    hash = "sha256-THTzoiwF34/detu3HkpcSufb5MwbUeB0giS3i4BB2C0=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "protobuf" ];

  dependencies = [
    google-api-core
    google-cloud-logging
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    google-cloud-testutils
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require credentials
    "test_report_error_event"
    "test_report_exception"
    # Import is already tested
    "test_namespace_package_compat"
  ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google
  '';

  pythonImportsCheck = [
    "google.cloud.error_reporting"
    "google.cloud.errorreporting_v1beta1"
  ];

  meta = {
    description = "Stackdriver Error Reporting API client library";
    homepage = "https://github.com/googleapis/python-error-reporting";
    changelog = "https://github.com/googleapis/python-error-reporting/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
