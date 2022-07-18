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
  version = "2.0.0";

  disabled = pythonOlder "3.6";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d739d00a9e4203cfaba34540c822a73ca1d327159ed7776b3dce09391f81c35d";
  };

  postPatch = ''
    substituteInPlace safety/safety.py \
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

  checkInputs = [
    pytestCheckHook
  ];

  # Disable tests depending on online services
  disabledTests = [
    "test_announcements_if_is_not_tty"
    "test_check_live"
    "test_check_live_cached"
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
