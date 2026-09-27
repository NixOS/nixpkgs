{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  httpx,
  pydantic,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "flow-it-api";
  version = "0.0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "albertogeniola";
    repo = "flow-it-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/X/sFtoqIu4lVUXOAgPI3299N2N0adDZILeBnpSL3GM=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    httpx
    pydantic
    websockets
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [ "flow_it_api" ];

  meta = {
    description = "Python API library client for the FlowIt VMC machine";
    homepage = "https://github.com/albertogeniola/flow-it-api";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
