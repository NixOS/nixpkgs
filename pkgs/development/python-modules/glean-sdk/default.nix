{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  glean-parser,
  pytest-localserver,
  pytestCheckHook,
  rustPlatform,
  semver,
  setuptools,
}:

buildPythonPackage rec {
  pname = "glean-sdk";
  version = "64.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "glean";
    rev = "v${version}";
    hash = "sha256-6UAZkVBxFJ1CWRn9enCLBBidIugAtxP7stbYlhh1ArA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-Ppc+6ex3yLC4xuhbZGZDKLqxDjSdGpgrLDpbbbqMgPY=";
  };

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

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Telemetry client libraries and are a part of the Glean project";
    homepage = "https://mozilla.github.io/glean/book/index.html";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ melling ];
  };
}
