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
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Taraman17";
    repo = "pyHomee";
    tag = "v${version}";
    hash = "sha256-kFsg1abnH9aL5dwSNwQ1WHPdZ6EApc48j8si92kR8ts=";
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
