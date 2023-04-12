{ lib
, buildPythonPackage
, fetchPypi
, jupyterhub
, escapism
, docker
}:

buildPythonPackage rec {
  pname = "dockerspawner";
  version = "12.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3894ed8a9157f8ac8f42e0130f43932490ac5d1e89e6f295b1252f08c00ba36b";
  };

  propagatedBuildInputs = [
    jupyterhub
    escapism
    docker
  ];

  # tests require docker
  doCheck = false;

  pythonImportsCheck = [ "dockerspawner" ];

  meta = with lib; {
    description = "Dockerspawner: A custom spawner for Jupyterhub";
    homepage = "https://jupyter.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
