{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatchling,
  setuptools,
  click,
  requests,
  packaging,
  dparse,
  ruamel-yaml,
  jinja2,
  marshmallow,
  nltk,
  authlib,
  typer,
  pydantic,
  safety-schemas,
  typing-extensions,
  filelock,
  psutil,
  httpx,
  tenacity,
  tomlkit,
  git,
  pytestCheckHook,
  tomli,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "safety";
  version = "3.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyupio";
    repo = "safety";
    tag = version;
    hash = "sha256-BPLK/V7YQBCGopfRFAWdra8ve8Ww5KN1+oZKyoEPiFc=";
  };

  patches = [
    ./disable-telemetry.patch
  ];

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "filelock"
    "pydantic"
    "psutil"
  ];

  dependencies = [
    setuptools
    click
    requests
    packaging
    dparse
    ruamel-yaml
    jinja2
    marshmallow
    nltk
    authlib
    typer
    pydantic
    safety-schemas
    typing-extensions
    filelock
    psutil
    httpx
    tenacity
    tomlkit
  ];

  nativeCheckInputs = [
    git
    pytestCheckHook
    tomli
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Disable tests depending on online services
    "test_announcements_if_is_not_tty"
    "test_check_live"
    "test_debug_flag"
    "test_get_packages_licenses_without_api_key"
    "test_init_project"
    "test_validate_with_basic_policy_file"
  ];

  # ImportError: cannot import name 'get_command_for' from partially initialized module 'safety.cli_util' (most likely due to a circular import)
  disabledTestPaths = [ "tests/alerts/test_utils.py" ];

  meta = {
    description = "Checks installed dependencies for known vulnerabilities";
    mainProgram = "safety";
    homepage = "https://github.com/pyupio/safety";
    changelog = "https://github.com/pyupio/safety/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      thomasdesr
      dotlambda
    ];
  };
}
