{ buildPythonPackage
, sanic-testing
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage {
  pname = "sanic-testing-tests";
  inherit (sanic-testing) version;

  src = sanic-testing.testsout;
  format = "other";

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    sanic-testing
  ];

  pythonImportsCheck = [
    "sanic_testing"
  ];
}
