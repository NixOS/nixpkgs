{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
  cookiecutter,
  importlib-metadata,
  pyscaffold,
  configupdater,
  pre-commit,
  pytest,
  pytest-cov,
  pytest-xdist,
  tox,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "pyscaffoldext-cookiecutter";
  version = "0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H++p/kPASs3IWk39fCXzq20QmMPGkG0bDTnVAm773cU=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    cookiecutter
    importlib-metadata
    pyscaffold
  ];

  optional-dependencies = {
    testing = [
      configupdater
      pre-commit
      pytest
      pytest-cov
      pytest-xdist
      setuptools-scm
      tox
      virtualenv
    ];
  };

  pythonImportsCheck = [ "pyscaffoldext.cookiecutter" ];

  meta = with lib; {
    description = "Integration of Cookiecutter project templates into PyScaffold (see: https://github.com/cookiecutter/cookiecutter";
    homepage = "https://pypi.org/project/pyscaffoldext-cookiecutter/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
