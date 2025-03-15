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
  git,
  pytestCheckHook,
  tomli,
}:

buildPythonPackage rec {
  pname = "safety";
  version = "3.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyupio";
    repo = "safety";
    tag = version;
    hash = "sha256-u+ysRpWLHDQdNRBSlYXz80e/MCT4smmv/YX8sfIrn24=";
  };

  postPatch = ''
    substituteInPlace safety/safety.py \
      --replace-fail "telemetry: bool = True" "telemetry: bool = False"
    substituteInPlace safety/util.py \
      --replace-fail "telemetry: bool = True" "telemetry: bool = False"
    substituteInPlace safety/cli.py \
      --replace-fail "disable-optional-telemetry', default=False" \
                     "disable-optional-telemetry', default=True"
    substituteInPlace safety/scan/finder/handlers.py \
      --replace-fail "telemetry=True" "telemetry=False"
  '';

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "pydantic"
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
  ];

  nativeCheckInputs = [
    git
    pytestCheckHook
    tomli
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

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = {
    description = "Checks installed dependencies for known vulnerabilities";
    mainProgram = "safety";
    homepage = "https://github.com/pyupio/safety";
    changelog = "https://github.com/pyupio/safety/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      thomasdesr
      dotlambda
    ];
  };
}
