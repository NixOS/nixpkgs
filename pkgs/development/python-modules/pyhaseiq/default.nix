{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyhaseiq";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "bbayszczak";
    repo = "pyhaseiq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cuG4gzDQAT+yAF7EwWdBG2hD6Q1X/LMGhEBSSlba6os=";
  };

  build-system = [ hatchling ];

  dependencies = [ websockets ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyhaseiq" ];

  meta = {
    description = "Read-only library for Hase iQ wood stoves over their local WebSocket";
    homepage = "https://github.com/bbayszczak/pyhaseiq";
    changelog = "https://github.com/bbayszczak/pyhaseiq/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
