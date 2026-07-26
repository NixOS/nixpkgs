{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "romy";
  version = "0.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xeniter";
    repo = "romy";
    tag = version;
    hash = "sha256-pQI+/1xt1YE+L5CHsurkBr2dKMGR/dV5vrGHYM8wNGs=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "romy" ];

  meta = {
    description = "Library to control Wi-Fi enabled ROMY vacuum cleaners";
    homepage = "https://github.com/xeniter/romy";
    changelog = "https://github.com/xeniter/romy/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
