{ lib
, aiocontextvars
, blinker
, buildPythonPackage
, fetchPypi
, fetchpatch
, httpx
, mock
, pytestCheckHook
, requests
, six
, pythonOlder
, webob
}:

buildPythonPackage rec {
  pname = "rollbar";
  version = "0.16.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AjE9/GBxDsc2qwM9D4yWnYV6i5kc1n4MGpFiDooE7eI=";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  nativeCheckInputs = [
    webob
    blinker
    mock
    httpx
    aiocontextvars
    pytestCheckHook
  ];

  # Still supporting unittest2
  # https://github.com/rollbar/pyrollbar/pull/346
  # https://github.com/rollbar/pyrollbar/pull/340
  doCheck = false;

  pythonImportsCheck = [
    "rollbar"
  ];

  meta = with lib; {
    description = "Error tracking and logging from Python to Rollbar";
    homepage = "https://github.com/rollbar/pyrollbar";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
