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

buildPythonPackage (finalAttrs: {
  pname = "huum";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frwickst";
    repo = "pyhuum";
    tag = finalAttrs.version;
    hash = "sha256-PM1At/AqKZ0QIJWlQeeTYqnQqK1wOnd4eRLyd7MvFLk=";
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

  meta = {
    description = "Library for Huum saunas";
    homepage = "https://github.com/frwickst/pyhuum";
    changelog = "https://github.com/frwickst/pyhuum/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
