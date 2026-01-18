{
  lib,
  asgiref,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  pytest-django,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-cors-headers";
  version = "4.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "django-cors-headers";
    tag = version;
    hash = "sha256-YtBMTmUOqozJksUgF4XJO+cQaFVt49qa0YKHlcXM1nU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asgiref
    django
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "corsheaders" ];

  meta = {
    description = "Django app for handling server Cross-Origin Resource Sharing (CORS) headers";
    homepage = "https://github.com/OttoYiu/django-cors-headers";
    changelog = "https://github.com/adamchainz/django-cors-headers/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
