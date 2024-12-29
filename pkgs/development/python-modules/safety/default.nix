{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  click,
  urllib3,
  requests,
  packaging,
  dparse,
  ruamel-yaml,
  jinja2,
  marshmallow,
  authlib,
  jwt,
  rich,
  typer,
  pydantic,
  safety-schemas,
  typing-extensions,
  filelock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "safety";
  version = "3.2.4";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-usAgIBbXNqIRgFeWSg45g/og/yVj/RA8rD86we0/6hE=";
  };

  postPatch = ''
    substituteInPlace safety/safety.py \
      --replace-fail "telemetry=True" "telemetry=False"
    substituteInPlace safety/util.py \
      --replace-fail "telemetry = True" "telemetry = False"
    substituteInPlace safety/cli.py \
      --replace-fail "disable-optional-telemetry', default=False" \
                     "disable-optional-telemetry', default=True"
    substituteInPlace safety/scan/finder/handlers.py \
      --replace-fail "telemetry=True" "telemetry=False"
  '';

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "dparse"
    "filelock"
  ];

  dependencies = [
    setuptools
    click
    urllib3
    requests
    packaging
    dparse
    ruamel-yaml
    jinja2
    marshmallow
    authlib
    jwt
    rich
    typer
    pydantic
    safety-schemas
    typing-extensions
    filelock
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Disable tests depending on online services
  disabledTests = [
    "test_announcements_if_is_not_tty"
    "test_check_live"
    "test_check_live_cached"
    "test_get_packages_licenses_without_api_key"
    "test_validate_with_policy_file_using_invalid_keyword"
    "test_validate_with_basic_policy_file"
  ];

  # ImportError: cannot import name 'get_command_for' from partially initialized module 'safety.cli_util' (most likely due to a circular import)
  disabledTestPaths = [ "tests/alerts/test_utils.py" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Checks installed dependencies for known vulnerabilities";
    mainProgram = "safety";
    homepage = "https://github.com/pyupio/safety";
    changelog = "https://github.com/pyupio/safety/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      thomasdesr
      dotlambda
    ];
  };
}
