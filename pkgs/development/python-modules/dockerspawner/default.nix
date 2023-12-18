{ lib
, buildPythonPackage
, fetchPypi
, jupyterhub
, escapism
, docker
}:

buildPythonPackage rec {
  pname = "dockerspawner";
  version = "13.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-POlTZ9luS9wQ/vt9w8VMfTEqGzg/DhfB45ePfvnyito=";
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
    maintainers = [ ];
  };
}
