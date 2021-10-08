{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, docker
, requests
, molecule
}:

buildPythonPackage rec {
  pname = "molecule-docker";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0psmsj6526pkyk47yik854acp9xxaj46gfx3iz15w7gb6jvknvx1";
  };

  propagatedBuildInputs = [
    docker
    molecule
    requests
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  pythonImportsCheck = [ "molecule_docker" ];

  meta = {
    description = "Molecule Docker Driver allows molecule users to test Ansible code using docker containers";
    homepage = "https://github.com/ansible-community/molecule-docker";
    maintainers = with lib.maintainers; [ ilpianista ];
    license = lib.licenses.mit;
  };
}
