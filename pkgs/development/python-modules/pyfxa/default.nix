{ lib
, buildPythonPackage
, cryptography
, fetchPypi
, grequests
, hawkauthlib
, mock
, pybrowserid
, pyjwt
, pytestCheckHook
, pythonOlder
, requests
, responses
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "pyfxa";
  version = "0.7.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyFxA";
    inherit version;
    hash = "sha256-bIXNCM8F9xON7hzyqKHWj9Qot7WtSIkXxwoqdj1lHNs=";
  };

  propagatedBuildInputs = [
    cryptography
    hawkauthlib
    pybrowserid
    pyjwt
    requests
    setuptools # imports pkg_resources
    six
  ];

  checkInputs = [
    grequests
    mock
    responses
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "fxa"
  ];

  disabledTestPaths = [
    # Requires network access
    "fxa/tests/test_core.py"
    "fxa/tests/test_oauth.py"
  ];

  meta = with lib; {
    description = "Firefox Accounts client library";
    homepage = "https://github.com/mozilla/PyFxA";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
  };
}
