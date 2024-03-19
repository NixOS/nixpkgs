{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, teamcity-messages
, testtools
}:

buildPythonPackage rec {
  pname = "flexmock";
  version = "0.11.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sf419qXzJUe1zTGhXAYNmrhj3Aiv8BjNc9x40bZR7dQ=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    teamcity-messages
    testtools
  ];

  disabledTests = [
    "test_failed_test_case"
  ];

  pythonImportsCheck = [
    "flexmock"
  ];

  meta = with lib; {
    description = "Testing library that makes it easy to create mocks,stubs and fakes";
    homepage = "https://flexmock.readthedocs.org";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ ];
  };
}
