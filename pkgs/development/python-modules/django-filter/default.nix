{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, django
, djangorestframework
, pytestCheckHook
, pytest-django
, pytz
}:

buildPythonPackage rec {
  pname = "django-filter";
  version = "24.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZctDzicgd+Wsaq4QVNdsEhzWtVLilqgqE5Iek3G6+ME=";
  };

  build-system = [ flit-core ];

  dependencies = [ django ];

  pythonImportsCheck = [
    "django_filters"
  ];

  nativeCheckInputs = [
    djangorestframework
    pytestCheckHook
    pytest-django
    pytz
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  meta = with lib; {
    description = "Reusable Django application for allowing users to filter querysets dynamically";
    homepage = "https://github.com/carltongibson/django-filter";
    changelog = "https://github.com/carltongibson/django-filter/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
