{
  lib,
  buildPythonPackage,
  dvc,
  fetchFromGitHub,
  pydrive2,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "dvc-gdrive";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-gdrive";
    tag = finalAttrs.version;
    hash = "sha256-oqHSMmwfR24ydJlpXGI3cCxIlF0BwNdgje5zKa0c7FA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dvc
    pydrive2
  ];

  # Circular dependency with dvc
  doCheck = false;

  pythonImportsCheck = [ "dvc_gdrive" ];

  meta = {
    description = "Google Drive plugin for DVC";
    homepage = "https://github.com/iterative/dvc-gdrive";
    changelog = "https://github.com/iterative/dvc-gdrive/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
