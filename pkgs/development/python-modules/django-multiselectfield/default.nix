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
  version = "0.1.13";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "django_multiselectfield";
    inherit version;
    hash = "sha256-Q31yYy9MDKQWlRkXYyUpw9HUK2K7bDwD4zlvpQJlvpQ=";
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
