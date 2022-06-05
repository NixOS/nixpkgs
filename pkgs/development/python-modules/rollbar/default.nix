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
  version = "0.16.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aa3b570062dd8dfb0e11537ba858f9e1633a604680e062a525434b8245540f87";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  checkInputs = [
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
