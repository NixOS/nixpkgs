{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pythonRelaxDepsHook
, setuptools
, click
, urllib3
, requests
, packaging
, dparse
, ruamel-yaml
, jinja2
, marshmallow
, authlib
, jwt
, rich
, typer
, pydantic
, safety-schemas
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "safety";
  version = "3.0.1";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HyAA8DZS86C/xn+P0emLxXI8y3bhXLG91oVFw9gD3wE=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Disable tests depending on online services
  disabledTests = [
    "test_announcements_if_is_not_tty"
    "test_check_live"
    "test_check_live_cached"
    "test_get_packages_licenses_without_api_key"
    "test_validate_with_policy_file_using_invalid_keyword"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Checks installed dependencies for known vulnerabilities";
    mainProgram = "safety";
    homepage = "https://github.com/pyupio/safety";
    changelog = "https://github.com/pyupio/safety/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ thomasdesr dotlambda ];
  };
}
