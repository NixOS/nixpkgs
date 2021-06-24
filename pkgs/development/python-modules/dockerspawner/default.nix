{ lib
, buildPythonPackage
, fetchPypi
, jupyterhub
, escapism
, docker
}:

buildPythonPackage rec {
  pname = "dockerspawner";
  version = "0.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83fd8ee012bb32432cb57bd408ff65534749aed8696648e6ac029a87fc474928";
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
