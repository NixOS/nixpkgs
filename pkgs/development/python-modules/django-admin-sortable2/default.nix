{
  lib,
  buildPythonPackage,
  django_4,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "django-admin-sortable2";
  version = "2.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "django_admin_sortable2";
    inherit version;
    hash = "sha256-MKlSf5P8YbeixZVNtX2EKJMeN/Riw7RssQEFPcX1F1E=";
  };

  propagatedBuildInputs = [ django_4 ];

  pythonImportsCheck = [ "adminsortable2" ];

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
