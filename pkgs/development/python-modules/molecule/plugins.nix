{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  python-vagrant,
  docker,
}:

buildPythonPackage rec {
  pname = "molecule-plugins";
  version = "25.8.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ansible-community";
    repo = "molecule-plugins";
    tag = "v${version}";
    hash = "sha256-wTvJ+cjZMTOyaqqDZsA1wsKCpu2FEi69IBlSTxNs3/M=";
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

  meta = {
    description = "Collection on molecule plugins";
    homepage = "https://github.com/ansible-community/molecule-plugins";
    maintainers = [ ];
    license = lib.licenses.mit;
    hasNoMaintainersButDependents = true;
  };
}
