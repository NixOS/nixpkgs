{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pynordpool";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gjohansson-ST";
    repo = "pynordpool";
    tag = "v${version}";
    hash = "sha256-HDbYrwQ4v5cqej5aUat0gVzaRpJz5jaFHjWUC98gacg=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pynordpool" ];

  meta = {
    description = "Python api for Nordpool";
    homepage = "https://github.com/gjohansson-ST/pynordpool";
    changelog = "https://github.com/gjohansson-ST/pynordpool/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
