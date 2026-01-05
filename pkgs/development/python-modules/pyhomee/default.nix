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
  version = "1.3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Taraman17";
    repo = "pyHomee";
    tag = "v${version}";
    hash = "sha256-7Op+l6gIyPPE4DX3XGi1hpgWRllOTbaqqUuop7JDMhY=";
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
