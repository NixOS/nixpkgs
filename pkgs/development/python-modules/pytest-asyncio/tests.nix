{ buildPythonPackage
, hypothesis
, pytest
, pytest-asyncio
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
    hypothesis
    pytestCheckHook
  ] ++ pytest.optional-dependencies.testing;
}
