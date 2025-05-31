{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "magicattr";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frmdstryr";
    repo = "magicattr";
    tag = "v${version}";
    hash = "sha256-hV425AnXoYL3oSYMhbXaF8VRe/B1s5f5noAZYz4MMwc=";
  };

  build-system = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests.py"
  ];

  pythonImportsCheck = [
    "magicattr"
  ];

  meta = {
    description = "Getattr and setattr that works on nested objects, lists, dicts, and any combination thereof without resorting to eval";
    homepage = "https://github.com/frmdstryr/magicattr";
    changelog = "https://github.com/frmdstryr/magicattr/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mcwitt ];
  };
}
