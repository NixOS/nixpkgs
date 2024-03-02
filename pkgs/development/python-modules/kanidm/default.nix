{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build
, poetry-core

# propagates
, aiohttp
, authlib
, pydantic
, toml

# tests
, pytest-asyncio
, pytest-mock
, pytestCheckHook
}:

let
  pname = "kanidm";
  version = "0.0.3-unstable-2023-08-23";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "kanidm";
    repo = "kanidm";
    rev = "def4420c4c5c3ec4f9b02776e1d5fdb07aa3a729";
    hash = "sha256-5qQb+Itguw2v1Wdvc2vp00zglfvNd3LFEDvaweRJcOc=";
  };

  sourceRoot = "source/pykanidm";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    authlib
    pydantic
    toml
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "-m 'not network'"
  ];

  pythonImportsCheck = [
    "kanidm"
  ];

  meta = with lib; {
    description = "Kanidm client library";
    homepage = "https://github.com/kanidm/kanidm/tree/master/pykanidm";
    license = licenses.mpl20;
    maintainers = with maintainers; [ arianvp hexa ];
  };
}
