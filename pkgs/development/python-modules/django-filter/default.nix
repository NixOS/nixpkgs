{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, django
, djangorestframework
, pytestCheckHook
, pytest-django
, python
}:

buildPythonPackage rec {
  pname = "django-filter";
  version = "23.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vtBws4NZ3OfS2+BXsWXVl3MFeYY1bLgJ3tmDs2x3qXY=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ django ];

  pythonImportsCheck = [
    "django_filters"
  ];

  nativeCheckInputs = [
    djangorestframework
    pytestCheckHook
    pytest-django
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
