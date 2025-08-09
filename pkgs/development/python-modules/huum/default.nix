{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "huum";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frwickst";
    repo = "pyhuum";
    tag = version;
    hash = "sha256-8wldXJAdo1PK4bKX0rKJjNwwTS5FSgr9RcwiyVhESb8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
  ]
  ++ aiohttp.optional-dependencies.speedups;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "huum" ];

  meta = with lib; {
    description = "Library for Huum saunas";
    homepage = "https://github.com/frwickst/pyhuum";
    changelog = "https://github.com/frwickst/pyhuum/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
