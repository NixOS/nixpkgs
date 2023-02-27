{ buildPythonPackage
, sanic
, sanic-testing
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage {
  pname = "sanic-testing-tests";
  inherit (sanic-testing) version;

  src = sanic-testing.testsout;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    sanic
  ];

  pythonImportsCheck = [
    "sanic_testing"
  ];
}
