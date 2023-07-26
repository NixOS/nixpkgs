{ lib
, buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook
, setuptools-scm
, python-vagrant
, docker
}:

buildPythonPackage rec {
  pname = "molecule-plugins";
  version = "23.5.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8T6gR7hlDIkmBLgbdjgryAu0riXqULI/MOgf2dWAKv8=";
  };

  # reverse the dependency
  pythonRemoveDeps = [
    "molecule"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools-scm
  ];

  passthru.optional-dependencies = {
    docker = [
      docker
    ];
    vagrant = [
      python-vagrant
    ];
  };

  pythonImportsCheck = [ "molecule_plugins" ];

  # Tests require container runtimes
  doCheck = false;

  meta = with lib; {
    description = "Collection on molecule plugins";
    homepage = "https://github.com/ansible-community/molecule-plugins";
    maintainers = with maintainers; [ dawidd6 ];
    license = licenses.mit;
  };
}
