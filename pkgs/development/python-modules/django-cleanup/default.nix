{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-cleanup";
  version = "9.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "django_cleanup";
    inherit version;
    hash = "sha256-u5+1YKr2KVnIHjH6QIhcNrvVhU1aohuQ3yx+S6YzUx4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ django ];

  pythonImportsCheck = [ "django_cleanup" ];

  meta = with lib; {
    description = "Automatically deletes old file for FileField and ImageField. It also deletes files on models instance deletion";
    homepage = "https://github.com/un1t/django-cleanup";
    changelog = "https://github.com/un1t/django-cleanup/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}
