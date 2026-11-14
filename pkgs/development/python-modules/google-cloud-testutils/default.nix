{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  google-auth,
  packaging,
  pytestCheckHook,
  setuptools,

  # update
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-testutils";
  version = "1.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-testutils-v${finalAttrs.version}";
    hash = "sha256-b0FYupZU0ZNeIL9xJIqEXgg7ToRCQLjiswJ67YzX7OI=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/google-cloud-testutils";

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

  # The ATOM feed loses this update most of the time due to a high update volume,
  # so query github directly.
  passthru = {
    # bulk updater uses wrong tag
    skipBulkUpdate = true;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "google-cloud-testutils-v([0-9.]+)"
        "--use-github-releases"
      ];
    };
  };

  meta = {
    description = "System test utilities for google-cloud-python";
    mainProgram = "lower-bound-checker";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-testutils";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-testutils-${finalAttrs.src.tag}/packages/google-cloud-testutils/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
})
