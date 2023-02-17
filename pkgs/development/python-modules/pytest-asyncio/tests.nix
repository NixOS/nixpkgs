{ buildPythonPackage
, flaky
, hypothesis
, pytest-asyncio
, pytest-trio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-asyncio-tests";
  inherit (pytest-asyncio) version;

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
