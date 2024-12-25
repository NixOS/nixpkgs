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
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fwestenberg";
    repo = "devialet";
    rev = "refs/tags/v${version}";
    hash = "sha256-FM6nZFkny3+LJYK5eUmg1VQag5jqCvmUKBlhTXrCosA=";
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
    changelog = "https://github.com/fwestenberg/devialet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
