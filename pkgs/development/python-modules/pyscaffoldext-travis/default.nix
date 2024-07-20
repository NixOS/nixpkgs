{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
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
  pname = "pyscaffoldext-travis";
  version = "0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ztAhA/2ctCHz5kggOAaXd3ed903ClTlhCfaGTl344zI=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    importlib-metadata
    pyscaffold
  ];

  passthru.optional-dependencies = {
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

  pythonImportsCheck = [ "pyscaffoldext.travis" ];

  meta = with lib; {
    description = "Travis CI configurations for PyScaffold";
    homepage = "https://pypi.org/project/pyscaffoldext-travis/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
