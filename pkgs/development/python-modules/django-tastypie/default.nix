{ lib
, buildPythonPackage
, fetchFromGitHub
, python-dateutil
, python-mimeparse
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-tastypie";
  version = "0.14.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "django-tastypie";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-O/aVi8BshOZmg9WQxrFlBEOXfgyqJKVK/QlEFG3Edqs=";
  };

  propagatedBuildInputs = [
    python-dateutil
    python-mimeparse
  ];

  # Tests requires a Django instance
  doCheck = false;

  pythonImportsCheck = [
    "tastypie"
  ];

  meta = with lib; {
    description = "Utilities and helpers for writing Pylint plugins";
    homepage = "https://github.com/django-tastypie/django-tastypie";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
