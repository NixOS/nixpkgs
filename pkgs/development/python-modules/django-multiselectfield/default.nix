{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-multiselectfield";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "django_multiselectfield";
    inherit version;
    hash = "sha256-P4tP/z4H1Kkci7S4Cbw1yusitBdptgb0ye3FO41ypmc=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "multiselectfield" ];

  meta = {
    description = "Multiple Choice model field for Django";
    homepage = "https://github.com/goinnn/django-multiselectfield";
    changelog = "https://github.com/goinnn/django-multiselectfield/blob/master/CHANGES.rst";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
  };
}
