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
  version = "0.7.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyFxA";
    inherit version;
    hash = "sha256-DMFZl1hbYNaScOTWkAbK2nKti6wD5SS5A30q7TW5vO4=";
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
