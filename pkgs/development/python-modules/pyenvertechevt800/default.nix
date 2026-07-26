{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyenvertechevt800";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "daniel-bergmann-00";
    repo = "pyenvertech-evt800";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JUXPyBnmwcKtGk2PjhKAaPZXnvl8Vkx9hrb7NurGvHo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyenvertechevt800" ];

  meta = {
    description = "Library to interface an Envertech EVT-800 device";
    homepage = "https://github.com/daniel-bergmann-00/pyenvertech-evt800";
    changelog = "https://github.com/daniel-bergmann-00/pyenvertech-evt800/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
