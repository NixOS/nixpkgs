{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  grequests,
  hawkauthlib,
  mock,
  pybrowserid,
  pyjwt,
  pytestCheckHook,
  pythonOlder,
  requests,
  responses,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "pyfxa";
  version = "0.7.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dTsWFWaqX6YypNJz9WSlcxJlYOstmTu2ZgOG3RPSViw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    hawkauthlib
    pybrowserid
    pyjwt
    requests
    setuptools # imports pkg_resources
    six
  ];

  nativeCheckInputs = [
    grequests
    mock
    responses
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fxa" ];

  disabledTestPaths = [
    # Requires network access
    "fxa/tests/test_core.py"
    "fxa/tests/test_oauth.py"
  ];

  meta = with lib; {
    description = "Firefox Accounts client library";
    mainProgram = "fxa-client";
    homepage = "https://github.com/mozilla/PyFxA";
    license = licenses.mpl20;
    maintainers = [ ];
  };
}
