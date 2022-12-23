{ lib, buildPythonPackage, django_4, fetchPypi }:

buildPythonPackage rec {
  pname = "django-admin-sortable2";
  version = "2.1.4";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-fcCP8PvOWFlQL4CdEIwElfOw2UYJJp6u27EjfgMISss=";
  };

  propagatedBuildInputs = [ django_4 ];

  pythonImportsCheck = [ "adminsortable2" ];

  # Tests are very slow (end-to-end with playwright)
  doCheck = false;

  meta = with lib; {
    description = "Generic drag-and-drop ordering for objects in the Django admin interface";
    homepage = "https://github.com/jrief/django-admin-sortable2";
    license = licenses.mit;
    maintainers = with maintainers; [ sephi ];
  };
}
