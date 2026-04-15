{
  aiofiles,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mashumaro,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  syrupy,
}:

buildPythonPackage rec {
  pname = "aioimmich";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mib1185";
    repo = "aioimmich";
    tag = "v${version}";
    hash = "sha256-p04FGEQXUGMGouy6bY0QW8rC7Ld5RaSoOV/UbAkmNwQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail setuptools==82.0.1 setuptools
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    mashumaro
  ];

  pythonImportsCheck = [ "aioimmich" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/mib1185/aioimmich/releases/tag/${src.tag}";
    description = "Asynchronous library to fetch albums and assests from immich";
    homepage = "https://github.com/mib1185/aioimmich";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
