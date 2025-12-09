{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  python-vagrant,
  docker,
}:

buildPythonPackage rec {
  pname = "molecule-plugins";
  version = "23.5.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-orFDfVMtc24/vG23pp7FM+IzSyEV/5JFoLJ3LtlzjSM=";
  };

  # reverse the dependency
  pythonRemoveDeps = [ "molecule" ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  optional-dependencies = {
    docker = [ docker ];
    vagrant = [ python-vagrant ];
  };

  pythonImportsCheck = [ "molecule_plugins" ];

  # Tests require container runtimes
  doCheck = false;

  meta = with lib; {
    description = "Collection on molecule plugins";
    homepage = "https://github.com/ansible-community/molecule-plugins";
    maintainers = [ ];
    license = licenses.mit;
  };
}
