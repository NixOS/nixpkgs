{ buildPythonPackage
, flaky
, hypothesis
, pytest-asyncio
, pytest-trio
, pytestCheckHook
}:

buildPythonPackage {
  pname = "pytest-asyncio-tests";
  inherit (pytest-asyncio) version;

  format = "other";

  src = pytest-asyncio.testout;

  dontBuild = true;
  dontInstall = true;

  propagatedBuildInputs = [
    pytest-asyncio
  ];

  nativeCheckInputs = [
    flaky
    hypothesis
    pytest-trio
    pytestCheckHook
  ];
}
