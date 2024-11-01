{
  lib,
  buildPythonPackage,
  colorful,
  fetchFromGitHub,
  git,
  httpx,
  lxml,
  packaging,
  poetry-core,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  semver,
  shtab,
  rich,
  tomlkit,
}:

buildPythonPackage rec {
  pname = "pontos";
  version = "24.9.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "pontos";
    rev = "refs/tags/v${version}";
    hash = "sha256-CgO88I2M8RGpYyJchXZtqxIBjNaULSqnDgfFCUQDFUw=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    colorful
    httpx
    lxml
    packaging
    python-dateutil
    semver
    shtab
    rich
    tomlkit
  ] ++ httpx.optional-dependencies.http2;

  nativeCheckInputs = [
    git
    pytestCheckHook
  ];

  disabledTests = [
    "PrepareTestCase"
    # Signing fails
    "test_find_no_signing_key"
    "test_find_signing_key"
    "test_find_unreleased_information"
    # CLI test fails
    "test_missing_cmd"
    "test_update_file_changed"
    # Network access
    "test_fail_sign_on_upload_fail"
    "test_successfully_sign"
    # calls git log, but our fetcher removes .git
    "test_git_error"
    # Tests require git executable
    "test_github_action_output"
    "test_initial_release"
    # Tests are out-dated
    "test_getting_version_without_version_config"
    "test_verify_version_does_not_match"
  ];

  pythonImportsCheck = [ "pontos" ];

  meta = with lib; {
    description = "Collection of Python utilities, tools, classes and functions";
    homepage = "https://github.com/greenbone/pontos";
    changelog = "https://github.com/greenbone/pontos/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
