{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  jupyterhub,
  escapism,
  docker,
}:

buildPythonPackage rec {
  pname = "dockerspawner";
  version = "14.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
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

  meta = with lib; {
    description = "Custom spawner for Jupyterhub";
    homepage = "https://github.com/jupyterhub/dockerspawner";
    changelog = "https://github.com/jupyterhub/dockerspawner/blob/${version}/docs/source/changelog.md";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
