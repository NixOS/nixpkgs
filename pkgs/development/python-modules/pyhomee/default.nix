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
  version = "1.2.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Taraman17";
    repo = "pyHomee";
    tag = "v${version}";
    hash = "sha256-pfWDVvEm/YXU83gSCLaU5/C5qwxJH3NFm0jpahpgMx4=";
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
