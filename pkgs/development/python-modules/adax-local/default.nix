{
  lib,
  aiohttp,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  async-timeout,
  setuptools,
}:

buildPythonPackage rec {
  pname = "adax-local";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyAdaxLocal";
    tag = version;
    hash = "sha256-8gVpUYQoE4V3ATR6zFAz/sARyEmHu9lYyGchTpS1eX8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    bleak
    bleak-retry-connector
    async-timeout
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "adax_local" ];

  meta = {
    description = "Module for local access to Adax";
    homepage = "https://github.com/Danielhiversen/pyAdaxLocal";
    changelog = "https://github.com/Danielhiversen/pyAdaxLocal/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
