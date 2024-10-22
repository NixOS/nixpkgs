{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  dulwich,
  mercurial,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "hg-git";
  version = "1.1.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "hg_git";
    inherit version;
    hash = "sha256-BZzcElZa0pMBSGXSiSB+d+YFhJMM5PAdT2Txq5qLZCU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dulwich
    mercurial
  ];

  pythonImportsCheck = [ "hggit" ];

  meta = with lib; {
    description = "Push and pull from a Git server using Mercurial";
    homepage = "https://hg-git.github.io/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ koral ];
  };
}
