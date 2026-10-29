{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  poetry-core,
  teamcity-messages,
  testtools,
}:

buildPythonPackage (finalAttrs: {
  pname = "flexmock";
  version = "0.13.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-aCnXoNf3Rtswh9qP2mL5JOUt9+zkBRwvWa1YbPWteXc=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pytestCheckHook
    teamcity-messages
    testtools
  ];

  pythonImportsCheck = [ "flexmock" ];

  meta = {
    description = "Testing library that makes it easy to create mocks,stubs and fakes";
    homepage = "https://flexmock.readthedocs.org";
    license = lib.licenses.bsdOriginal;
    maintainers = [ ];
  };
})
