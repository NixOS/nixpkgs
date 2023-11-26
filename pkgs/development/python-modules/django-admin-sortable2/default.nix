{ lib
, buildPythonPackage
, django_4
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-admin-sortable2";
  version = "2.1.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-N1awLH0JxbN+/mV3GNWq4rdfRv0Bu/4cOdTmBlEBnXk=";
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
