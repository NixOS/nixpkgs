{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyhomee";
  version = "1.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Taraman17";
    repo = "pyHomee";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/qLs/ZmGc0N3Fs78Jbd0SbeMMf/gzMrXmrbeBFc7O6k=";
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
    changelog = "https://github.com/Taraman17/pyHomee/releases/tag/${finalAttrs.src.tag}";
    description = "Python library to interact with homee";
    homepage = "https://github.com/Taraman17/pyHomee";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
