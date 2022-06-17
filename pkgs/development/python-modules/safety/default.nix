{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, click
, requests
, packaging
, dparse
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "safety";
  version = "1.10.3";

  disabled = pythonOlder "3.5";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MOOU0CogrEm39lKS0Z04+pJ6j5WCzf060a27xmxkGtU=";
  };

  propagatedBuildInputs = [
    setuptools
    click
    requests
    packaging
    dparse
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # Disable tests depending on online services
  disabledTests = [
    "test_check_live"
    "test_check_live_cached"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Checks installed dependencies for known vulnerabilities";
    homepage = "https://github.com/pyupio/safety";
    license = licenses.mit;
    maintainers = with maintainers; [ thomasdesr dotlambda ];
  };
}
