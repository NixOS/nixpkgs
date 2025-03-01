{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pynordpool";
  version = "0.2.4";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "gjohansson-ST";
    repo = "pynordpool";
    tag = "v${version}";
    hash = "sha256-OGCVNVFbJfhjNKKpLRUvZIj7ZIYz/IVlt9xEPJb5W8E=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pynordpool" ];

  meta = {
    description = "Python api for Nordpool";
    homepage = "https://github.com/gjohansson-ST/pynordpool";
    changelog = "https://github.com/gjohansson-ST/pynordpool/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
