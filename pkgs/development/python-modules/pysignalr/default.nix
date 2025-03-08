{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  msgpack,
  orjson,
  websockets,
}:

buildPythonPackage rec {
  pname = "pysignalr";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "baking-bad";
    repo = "pysignalr";
    tag = "${version}";
    hash = "sha256-o9OXGdhdPPLJcEK3EmwhAhYg1VGkEaf+qo1RL/1LZgQ=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    aiohttp
    msgpack
    orjson
    websockets
  ];

  meta = {
    description = "Modern, reliable and async-ready client for SignalR protocol";
    homepage = "https://github.com/baking-bad/pysignalr";
    changelog = "https://github.com/baking-bad/pysignalr/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
