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

  # passthru
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-error-reporting";
  version = "1.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-error-reporting-v${finalAttrs.version}";
    hash = "sha256-b0FYupZU0ZNeIL9xJIqEXgg7ToRCQLjiswJ67YzX7OI=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/google-cloud-error-reporting";

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

  # The ATOM feed loses this update most of the time due to a high update volume,
  # so query github directly.
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "google-cloud-error-reporting-v([0-9.]+)"
      "--use-github-releases"
    ];
  };

  meta = {
    description = "Stackdriver Error Reporting API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-error-reporting";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${finalAttrs.src.tag}/packages/google-cloud-error-reporting/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
})
