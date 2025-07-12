{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  poetry-core,
  teamcity-messages,
  testtools,
}:

buildPythonPackage rec {
  pname = "flexmock";
  version = "0.12.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q1xmHDs1R3V165FQQooc/Xxiy5kqp4h1Z8M1euvJrKE=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pytestCheckHook
    teamcity-messages
    testtools
  ];

  pythonImportsCheck = [ "flexmock" ];

  meta = with lib; {
    description = "Testing library that makes it easy to create mocks,stubs and fakes";
    homepage = "https://flexmock.readthedocs.org";
    license = licenses.bsdOriginal;
    maintainers = [ ];
  };
}
