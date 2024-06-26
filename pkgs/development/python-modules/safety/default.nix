{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  pythonRelaxDepsHook,
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
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "safety";
  version = "3.2.3";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QUFUk08XJ9r4pkc0k5RP7LOAVAw/AIddwa43c4L32D8=";
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

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  pythonRelaxDeps = [
    "packaging"
    "dparse"
    "authlib"
    "pydantic"
  ];

  propagatedBuildInputs = [
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
