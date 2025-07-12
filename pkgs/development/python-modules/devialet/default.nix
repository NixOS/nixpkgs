{
  lib,
  aiohttp,
  async-upnp-client,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "devialet";
  version = "1.5.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fwestenberg";
    repo = "devialet";
    tag = "v${version}";
    hash = "sha256-HmTiHa7DEmjARaYn7/OoGotnTirE7S7zXLK/TfHdEAg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-upnp-client
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "devialet" ];

  meta = with lib; {
    description = "Library to interact with the Devialet API";
    homepage = "https://github.com/fwestenberg/devialet";
    changelog = "https://github.com/fwestenberg/devialet/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
