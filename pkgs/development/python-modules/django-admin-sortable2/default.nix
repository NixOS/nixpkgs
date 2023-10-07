{ lib
, buildPythonPackage
, django_4
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-admin-sortable2";
  version = "2.1.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-vwNnhcWYaFoAGesINAuI/mynS9F4Az4ikObEG2L6S/E=";
  };

  propagatedBuildInputs = [
    django_4
  ];

  pythonImportsCheck = [
    "adminsortable2"
  ];

  # Tests are very slow (end-to-end with playwright)
  doCheck = false;

  meta = with lib; {
    description = "Generic drag-and-drop ordering for objects in the Django admin interface";
    homepage = "https://github.com/jrief/django-admin-sortable2";
    changelog = "https://github.com/jrief/django-admin-sortable2/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ sephi ];
  };
}
