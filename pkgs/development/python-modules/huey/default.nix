{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  redis,
}:

buildPythonPackage (finalAttrs: {
  pname = "huey";
  version = "3.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = "huey";
    tag = finalAttrs.version;
    hash = "sha256-FFBRi0W37KuIJjif132za74XcYxXquP5gCLny4Ii29s=";
  };

  build-system = [ setuptools ];

  dependencies = [ redis ];

  # connects to redis
  doCheck = false;

  pythonImportsCheck = [ "huey" ];

  meta = {
    description = "Module to queue tasks";
    homepage = "https://github.com/coleifer/huey";
    changelog = "https://github.com/coleifer/huey/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
