{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
  importlib-metadata,
  pyscaffold,
  pyscaffoldext-markdown,
  configupdater,
  pre-commit,
  pytest,
  pytest-cov,
  pytest-xdist,
  tox,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "pyscaffoldext-dsproject";
  version = "0.7.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SF99noD6C31p4LWlwVAwArPYeNspF+ARK8Dzl5B1T9g=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    importlib-metadata
    pyscaffold
    pyscaffoldext-markdown
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

  pythonImportsCheck = [ "pyscaffoldext.dsproject" ];

  meta = with lib; {
    description = "PyScaffold extension for Data Science projects";
    homepage = "https://pypi.org/project/pyscaffoldext-dsproject/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
