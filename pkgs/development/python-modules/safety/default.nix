{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, click
, requests
, packaging
, dparse
, ruamel-yaml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "safety";
  version = "2.3.5";

  disabled = pythonOlder "3.6";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pgwR+JUvQSy7Fl1wyx9nOjtDorqak84R+X5qTeg0qjo=";
  };

  postPatch = ''
    substituteInPlace safety/safety.py \
      --replace "telemetry=True" "telemetry=False"
    substituteInPlace safety/util.py \
      --replace "telemetry=True" "telemetry=False"
    substituteInPlace safety/cli.py \
      --replace "telemetry', default=True" "telemetry', default=False"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    setuptools
    click
    requests
    packaging
    dparse
    ruamel-yaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Disable tests depending on online services
  disabledTests = [
    "test_announcements_if_is_not_tty"
    "test_check_live"
    "test_check_live_cached"
    "test_check_vulnerabilities"
    "test_license"
    "test_chained_review"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Checks installed dependencies for known vulnerabilities";
    homepage = "https://github.com/pyupio/safety";
    changelog = "https://github.com/pyupio/safety/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ thomasdesr dotlambda ];
  };
}
