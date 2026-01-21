{
  lib,
  appdirs,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "platformdirs";
  version = "4.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "platformdirs";
    tag = version;
    hash = "sha256-wDhhfS8r0fCYOUJUu2kwH+fyTPmS+aPUiqWN21Fedoc=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    appdirs
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "platformdirs" ];

  meta = {
    description = "Module for determining appropriate platform-specific directories";
    homepage = "https://platformdirs.readthedocs.io/";
    changelog = "https://github.com/tox-dev/platformdirs/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
