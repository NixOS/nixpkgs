{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "django-cleanup";
  version = "8.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cN+QUHakTnoRGzEZgZmvYz3uCIduGZ5tzjbKjda4sQ8=";
  };

  nativeCheckInputs = [ django ];

  meta = with lib; {
    description = "Automatically deletes old file for FileField and ImageField. It also deletes files on models instance deletion";
    homepage = "https://github.com/un1t/django-cleanup";
    changelog = "https://github.com/un1t/django-cleanup/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}
