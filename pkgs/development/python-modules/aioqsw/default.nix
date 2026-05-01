{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioqsw";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = "aioqsw";
    tag = version;
    hash = "sha256-SIdEM5YxPnCM6wEJTL19t07Xb89wDAwHzKnz0dKC0tw=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioqsw" ];

  meta = {
    description = "Library to fetch data from QNAP QSW switches";
    homepage = "https://github.com/Noltari/aioqsw";
    changelog = "https://github.com/Noltari/aioqsw/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
