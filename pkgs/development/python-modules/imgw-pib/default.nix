{
  aiofiles,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  lib,
  orjson,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  syrupy,
}:

buildPythonPackage rec {
  pname = "imgw-pib";
  version = "1.5.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "imgw-pib";
    tag = version;
    hash = "sha256-U1kC8+614U00LZbomx4bqf5pR/ZZDGx3u3bmUHZaDJ4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    orjson
  ];

  pythonImportsCheck = [ "imgw_pib" ];

  nativeCheckInputs = [
    aioresponses
    freezegun
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/bieniu/imgw-pib/releases/tag/${src.tag}";
    description = "Python async wrapper for IMGW-PIB API";
    homepage = "https://github.com/bieniu/imgw-pib";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
