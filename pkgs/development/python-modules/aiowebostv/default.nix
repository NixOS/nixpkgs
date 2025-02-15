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
  version = "0.6.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aiowebostv";
    tag = "v${version}";
    hash = "sha256-H5ZhG69F5w1fZBepxqWGo29XnK3Tn6dgota64k2GJbw=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "aiowebostv" ];

  meta = with lib; {
    description = "Module to interact with LG webOS based TV devices";
    homepage = "https://github.com/home-assistant-libs/aiowebostv";
    changelog = "https://github.com/home-assistant-libs/aiowebostv/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
