{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "huum";
  version = "0.8.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "frwickst";
    repo = "pyhuum";
    tag = version;
    hash = "sha256-8wldXJAdo1PK4bKX0rKJjNwwTS5FSgr9RcwiyVhESb8=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    mashumaro
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "huum" ];

  meta = with lib; {
    description = "Library for Huum saunas";
    homepage = "https://github.com/frwickst/pyhuum";
    changelog = "https://github.com/frwickst/pyhuum/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
