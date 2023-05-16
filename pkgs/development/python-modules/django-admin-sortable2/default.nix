{ lib
, buildPythonPackage
, django_4
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-admin-sortable2";
<<<<<<< HEAD
  version = "2.1.9";
=======
  version = "2.1.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version pname;
<<<<<<< HEAD
    hash = "sha256-vwNnhcWYaFoAGesINAuI/mynS9F4Az4ikObEG2L6S/E=";
=======
    hash = "sha256-aTOpu6nb7cShBrtIjkuKH7hcvgRZ+0ZQT+YC1l2/0+k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
