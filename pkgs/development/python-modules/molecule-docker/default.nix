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
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dc9a8ad60b70ede303805cd6865deb5fb9c162e67ff5e7d1a45eb7e58cd36b88";
  };

  propagatedBuildInputs = [
    docker
    molecule
    requests
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  # Disabled because there's a conflict when resolving the ansible dependency
  doCheck = false;

  pythonImportsCheck = [ "molecule_docker" ];

  meta = {
    description = "Molecule Docker Driver allows molecule users to test Ansible code using docker containers";
    homepage = "https://github.com/ansible-community/molecule-docker";
    maintainers = with lib.maintainers; [ ilpianista ];
    license = lib.licenses.mit;
  };
}
