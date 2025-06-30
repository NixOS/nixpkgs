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
  hatchling,
  parameterized,
}:

buildPythonPackage rec {
  pname = "pyfxa";
  version = "0.8.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3zxXWzFOjWcnX8hAQpRzGlzTmnXjZjn9jF+MdsHuGkw=";
  };

  build-system = [ hatchling ];

  dependencies = [
    cryptography
    hawkauthlib
    pybrowserid
    pyjwt
    requests
  ];

  nativeCheckInputs = [
    grequests
    mock
    responses
    pytestCheckHook
    parameterized
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
