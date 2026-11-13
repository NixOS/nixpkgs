{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "puremagic";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cdgriffith";
    repo = "puremagic";
    tag = finalAttrs.version;
    hash = "sha256-Mvhn/1xcgYgVkWok2qZXAe40pocfu6nJo5xuPruw2dc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "puremagic" ];

  meta = {
    description = "Implementation of magic file detection";
    homepage = "https://github.com/cdgriffith/puremagic";
    changelog = "https://github.com/cdgriffith/puremagic/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
