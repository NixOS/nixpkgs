{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "aiowebostv";
  version = "0.7.4";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aiowebostv";
    tag = "v${version}";
    hash = "sha256-VBdHI6aGfhcgDdwspToHp3iNFQRT0Z+Fseq0eNdUwTo=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "aiowebostv" ];

  meta = with lib; {
    description = "Module to interact with LG webOS based TV devices";
    homepage = "https://github.com/home-assistant-libs/aiowebostv";
    changelog = "https://github.com/home-assistant-libs/aiowebostv/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
