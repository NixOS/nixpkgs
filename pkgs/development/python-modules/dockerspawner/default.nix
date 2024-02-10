{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, jupyterhub
, escapism
, docker
}:

buildPythonPackage rec {
  pname = "dockerspawner";
  version = "13.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-POlTZ9luS9wQ/vt9w8VMfTEqGzg/DhfB45ePfvnyito=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    jupyterhub
    escapism
    docker
  ];

  # tests require docker
  doCheck = false;

  pythonImportsCheck = [
    "dockerspawner"
  ];

  meta = with lib; {
    description = "A custom spawner for Jupyterhub";
    homepage = "https://github.com/jupyterhub/dockerspawner";
    changelog = "https://github.com/jupyterhub/dockerspawner/blob/${version}/docs/source/changelog.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
