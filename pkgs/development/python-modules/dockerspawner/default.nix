{ lib
, buildPythonPackage
, fetchPypi
, jupyterhub
, escapism
, docker
}:

buildPythonPackage rec {
  pname = "dockerspawner";
  version = "12.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2cf2f4284b71f0bf34bc79c622f54805275167c83b446dfc05d8ee27294d60b";
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
