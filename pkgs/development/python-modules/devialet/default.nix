{
  lib,
  aiohttp,
  async-upnp-client,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "devialet";
  version = "1.5.7";
  pyproject = true;

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

  meta = {
    description = "Library to interact with the Devialet API";
    homepage = "https://github.com/fwestenberg/devialet";
    changelog = "https://github.com/fwestenberg/devialet/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
