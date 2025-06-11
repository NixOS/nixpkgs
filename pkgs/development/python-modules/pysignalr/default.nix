{
  aiohttp,
  buildPythonPackage,
  docker,
  fetchFromGitHub,
  lib,
  msgpack,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  websockets,
}:

buildPythonPackage rec {
  pname = "pysignalr";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "baking-bad";
    repo = "pysignalr";
    tag = version;
    hash = "sha256-3VZuS5q4b85Kuk2B00AeVpLGO232GN8tlfu6UaGmzjE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    msgpack
    orjson
    websockets
  ];

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
