{ lib
, buildPythonPackage
, fetchFromGitHub
, orjson
, quantile-python
, aiohttp
, aiohttp-basicauth
, starlette
, quart
, pytestCheckHook
, httpx
, fastapi
, uvicorn
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioprometheus";
  version = "unstable-2023-03-14";
  format = "setuptools";

  disable = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "claws";
    repo = "aioprometheus";
    rev = "4786678b413d166c0b6e0041558d11bc1a7097b2";
    hash = "sha256-2z68rQkMjYqkszg5Noj9owWUWQGOEp/91RGiWiyZVOY=";
  };

  propagatedBuildInputs = [
    orjson
    quantile-python
  ];

  passthru.optional-dependencies = {
    aiohttp = [
      aiohttp
    ];
    starlette = [
      starlette
    ];
    quart = [
      quart
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    aiohttp-basicauth
    httpx
    fastapi
    uvicorn
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "aioprometheus" ];

  meta = with lib; {
    description = "A Prometheus Python client library for asyncio-based applications";
    homepage = "https://github.com/claws/aioprometheus";
    changelog = "https://github.com/claws/aioprometheus/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
