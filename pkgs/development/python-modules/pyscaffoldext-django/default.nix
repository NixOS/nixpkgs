{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  django,
  pyscaffold,
}:

buildPythonPackage rec {
  pname = "pyscaffoldext-django";
  version = "0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5yzF3VK/9VlCSrRsRJWX4arr9n34G2R6O5A51jTpLhg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    django
    pyscaffold
  ];

  pythonRelaxDeps = [ "django" ];

  doCheck = false; # tests require git checkout

  pythonImportsCheck = [ "pyscaffoldext.django" ];

  meta = {
    description = "Integration of django builtin scaffold cli (django-admin) into PyScaffold";
    homepage = "https://pypi.org/project/pyscaffoldext-django/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
