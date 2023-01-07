{ lib
, buildPythonPackage
, django
, fetchPypi
, pytest-django
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-treebeard";
  version = "4.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-frHrcbJCFPLn3DvSFfDDrjL9Z2QXnNR3SveqtJE53qA=";
  };

  propagatedBuildInputs = [
    django
  ];

  checkInputs = [
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "treebeard"
  ];

  meta = with lib; {
    description = "Efficient tree implementations for Django";
    homepage = "https://tabo.pe/projects/django-treebeard/";
    changelog = "https://github.com/django-treebeard/django-treebeard/blob/${version}/CHANGES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };
}
