{
  aiohttp,
  buildPythonPackage,
  docker,
  fetchFromGitHub,
  hatchling,
  lib,
  msgpack,
  orjson,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  websockets,
}:

buildPythonPackage rec {
  pname = "pysignalr";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "baking-bad";
    repo = "pysignalr";
    tag = version;
    hash = "sha256-/Wa2ZeIuvF/4hM79N0rL0DxrBV60BM8/4uvV6ma79Xk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    msgpack
    orjson
    websockets
  ];

  pythonRelaxDeps = [ "websockets" ];

  pythonImportsCheck = [ "pysignalr" ];

  nativeCheckInputs = [
    docker
    pytest-asyncio
    pytestCheckHook
    requests
  ];

  meta = {
    changelog = "https://github.com/baking-bad/pysignalr/blob/${src.tag}/CHANGELOG.md";
    description = "Modern, reliable and async-ready client for SignalR protocol";
    homepage = "https://github.com/baking-bad/pysignalr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
