{
  lib,
  buildPythonPackage,
  fetchPypi,
<<<<<<< HEAD

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  django,
  pyscaffold,
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "pyscaffoldext-django";
  version = "0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5yzF3VK/9VlCSrRsRJWX4arr9n34G2R6O5A51jTpLhg=";
  };

<<<<<<< HEAD
  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
=======
  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    django
    pyscaffold
  ];

<<<<<<< HEAD
  pythonRelaxDeps = [ "django" ];

  doCheck = false; # tests require git checkout

  pythonImportsCheck = [ "pyscaffoldext.django" ];

  meta = {
    description = "Integration of django builtin scaffold cli (django-admin) into PyScaffold";
    homepage = "https://pypi.org/project/pyscaffoldext-django/";
    license = lib.licenses.mit;
=======
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

  pythonImportsCheck = [ "pyscaffoldext.django" ];

  meta = with lib; {
    description = "Integration of django builtin scaffold cli (django-admin) into PyScaffold";
    homepage = "https://pypi.org/project/pyscaffoldext-django/";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
