{
  lib,
  authlib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  mashumaro,
  orjson,
  pytest-asyncio,
  pytest-httpx,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  respx,
}:

buildPythonPackage rec {
  pname = "pydiscovergy";
  version = "3.0.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jpbede";
    repo = "pydiscovergy";
    rev = "refs/tags/v${version}";
    hash = "sha256-g6KWX7APdqB0dNe7p6WGualxSj5fiw+jRq+0qfqTs4w=";
  };

  postPatch = ''
    sed -i '/addopts =/d' pyproject.toml
  '';

  build-system = [ poetry-core ];

  dependencies = [
    authlib
    httpx
    mashumaro
    orjson
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "pydiscovergy" ];

  meta = with lib; {
    description = "Library for interacting with the Discovergy API";
    homepage = "https://github.com/jpbede/pydiscovergy";
    changelog = "https://github.com/jpbede/pydiscovergy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
