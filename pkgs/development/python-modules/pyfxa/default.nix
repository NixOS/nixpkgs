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
  requests,
  responses,
  hatchling,
  parameterized,
}:

buildPythonPackage rec {
  pname = "pyfxa";
  version = "0.8.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gq/OfpKjw6BSbGKTXbRa2crxleJJoj0BN4Ful1npWlw=";
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

  meta = {
    description = "Firefox Accounts client library";
    mainProgram = "fxa-client";
    homepage = "https://github.com/mozilla/PyFxA";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
}
