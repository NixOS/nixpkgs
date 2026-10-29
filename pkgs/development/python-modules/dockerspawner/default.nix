{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  jupyterhub,
  escapism,
  docker,
}:

buildPythonPackage (finalAttrs: {
  pname = "dockerspawner";
  version = "14.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-VkHUdj7MeMGxw8diG/6IwFVZaJPkO+f2buDcysBsHSo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    jupyterhub
    escapism
    docker
  ];

  # tests require docker
  doCheck = false;

  pythonImportsCheck = [ "dockerspawner" ];

  meta = {
    description = "Custom spawner for Jupyterhub";
    homepage = "https://github.com/jupyterhub/dockerspawner";
    changelog = "https://github.com/jupyterhub/dockerspawner/blob/${finalAttrs.version}/docs/source/changelog.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
