{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyrympro";
  version = "0.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "pyrympro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EHYgFAKlkHfrTzhv2VeBeikyoN1wrYejmwxktxuISZw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyrympro" ];

  meta = {
    description = "Module to interact with Read Your Meter Pro";
    homepage = "https://github.com/OnFreund/pyrympro";
    changelog = "https://github.com/OnFreund/pyrympro/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
