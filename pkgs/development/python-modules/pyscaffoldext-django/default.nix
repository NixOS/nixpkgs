{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
  django,
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
  pname = "pyscaffoldext-django";
  version = "0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5yzF3VK/9VlCSrRsRJWX4arr9n34G2R6O5A51jTpLhg=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    django
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

  pythonImportsCheck = [ "pyscaffoldext.django" ];

  meta = with lib; {
    description = "Integration of django builtin scaffold cli (django-admin) into PyScaffold";
    homepage = "https://pypi.org/project/pyscaffoldext-django/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
