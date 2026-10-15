{
  aiofiles,
  aiohttp,
  aiointercept,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mashumaro,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  syrupy_6,
}:

buildPythonPackage rec {
  pname = "aioimmich";
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mib1185";
    repo = "aioimmich";
    tag = "v${version}";
    hash = "sha256-8xqx5iC3IMW90bucKf2M1mEu3mephX0RjVujjvXBa2g=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail setuptools==84.0.0 setuptools
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    mashumaro
  ];

  pythonImportsCheck = [ "aioimmich" ];

  nativeCheckInputs = [
    aiointercept
    pytest-asyncio
    pytestCheckHook
    syrupy_6
  ];

  meta = {
    changelog = "https://github.com/mib1185/aioimmich/releases/tag/${src.tag}";
    description = "Asynchronous library to fetch albums and assets from immich";
    homepage = "https://github.com/mib1185/aioimmich";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
