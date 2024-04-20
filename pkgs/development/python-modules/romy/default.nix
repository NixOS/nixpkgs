{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "romy";
  version = "0.0.10";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "xeniter";
    repo = "romy";
    rev = "refs/tags/${version}";
    hash = "sha256-pQI+/1xt1YE+L5CHsurkBr2dKMGR/dV5vrGHYM8wNGs=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "romy" ];

  meta = with lib; {
    description = "Library to control Wi-Fi enabled ROMY vacuum cleaners";
    homepage = "https://github.com/xeniter/romy";
    changelog = "https://github.com/xeniter/romy/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
