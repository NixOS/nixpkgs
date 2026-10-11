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
  version = "26.9.28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ansible-community";
    repo = "molecule-plugins";
    tag = "v${version}";
    hash = "sha256-jKVxHgja5n3zOOWadkNGCqAw/nl/MwrR2YqzcjK0KkQ=";
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
  };
}
