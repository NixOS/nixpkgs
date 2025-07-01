{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
  configupdater,
  importlib-metadata,
  packaging,
  pyscaffold,
  pre-commit,
  pytest,
  pytest-cov,
  pytest-xdist,
  tox,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "pyscaffoldext-custom-extension";
  version = "0.6.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xHtKNqLSCTlbbXubADfLYjD3/53WfM65rRuh9RsyeN4=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    configupdater
    importlib-metadata
    packaging
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

  pythonImportsCheck = [ "pyscaffoldext.custom_extension" ];

  meta = with lib; {
    description = "PyScaffold extension to create a custom PyScaffold extension";
    homepage = "https://pypi.org/project/pyscaffoldext-custom-extension/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
