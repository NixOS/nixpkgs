{
  lib,
  appdirs,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "platformdirs";
  version = "4.14.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "platformdirs";
    tag = finalAttrs.version;
    hash = "sha256-zFUNzqU0i5nckkQMQwZyMw5J/IRmhqvQjqr65+AsjsY=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    appdirs
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "platformdirs" ];

  preCheck = ''
    unset XDG_DATA_DIRS
  '';

  meta = {
    description = "Module for determining appropriate platform-specific directories";
    homepage = "https://platformdirs.readthedocs.io/";
    changelog = "https://github.com/tox-dev/platformdirs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
