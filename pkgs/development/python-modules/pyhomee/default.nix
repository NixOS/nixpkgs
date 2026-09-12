{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  websockets,
}:

buildPythonPackage rec {
  pname = "pyhomee";
  version = "1.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Taraman17";
    repo = "pyHomee";
    tag = "v${version}";
    hash = "sha256-wHLMifPDZxwZA9d3QQG89JYqzc8AevqMd5SEJFpur70=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    websockets
  ];

  pythonImportsCheck = [ "pyHomee" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/Taraman17/pyHomee/releases/tag/${src.tag}";
    description = "Python library to interact with homee";
    homepage = "https://github.com/Taraman17/pyHomee";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
