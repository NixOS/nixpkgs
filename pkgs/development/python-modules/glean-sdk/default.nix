{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  glean-parser,
  nix-update-script,
  pytest-localserver,
  pytestCheckHook,
  rustPlatform,
  semver,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "glean-sdk";
  version = "69.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "glean";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KLYGbnKxuokvV/TBXLl1oplbTJkqMblh14daWalVz0M=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Vmxt8cRvkj0xEOc/WGDUxeQfH0uBvvboKc43ClqqEaQ=";
  };

  dontStrip = true;

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    setuptools
  ];

  dependencies = [
    glean-parser
    semver
  ];

  nativeCheckInputs = [
    pytest-localserver
    pytestCheckHook
  ];

  enabledTestPaths = [ "glean-core/python/tests" ];

  disabledTests = [
    # RuntimeError: No ping received.
    "test_client_activity_api"
    "test_flipping_upload_enabled_respects_order_of_events"
    # A warning causes this test to fail
    "test_get_language_tag_reports_the_tag_for_the_default_locale"
  ];

  pythonImportsCheck = [ "glean" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    broken = true; # fails to build since 2025-12
    description = "Telemetry client libraries and are a part of the Glean project";
    homepage = "https://mozilla.github.io/glean/book/index.html";
    maintainers = with lib.maintainers; [ choco98 ];
    license = lib.licenses.mpl20;
  };
})
