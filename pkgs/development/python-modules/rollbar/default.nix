{ aiocontextvars
, blinker
, buildPythonPackage
, fetchPypi
, httpx
, lib
, mock
, pytestCheckHook
, requests
, six
, unittest2
, webob
}:

buildPythonPackage rec {
  pname = "rollbar";
  version = "0.16.2";

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
    unittest2
    mock
    httpx
    aiocontextvars
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rollbar" ];

  meta = with lib; {
    description = "Error tracking and logging from Python to Rollbar";
    homepage = "https://github.com/rollbar/pyrollbar";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
