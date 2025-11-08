{
  lib,
  aiohttp,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  async-timeout,
  setuptools,
}:

buildPythonPackage rec {
  pname = "adax-local";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyAdaxLocal";
    tag = version;
    hash = "sha256-HdhatjlN4oUzBV1cf/PfgOJbEks4KBdw4vH8Y/z6efQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    bleak
    async-timeout
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "adax_local" ];

  meta = with lib; {
    description = "Module for local access to Adax";
    homepage = "https://github.com/Danielhiversen/pyAdaxLocal";
    changelog = "https://github.com/Danielhiversen/pyAdaxLocal/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
