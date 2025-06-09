{
  lib,
  asgiref,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  pytest-django,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-cors-headers";
  version = "4.7.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "django-cors-headers";
    tag = version;
    hash = "sha256-xKdHUGsl9H724IQn/AFtdumB/TH8m2pUUXs263gYsEg=";
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

  meta = with lib; {
    description = "Django app for handling server Cross-Origin Resource Sharing (CORS) headers";
    homepage = "https://github.com/OttoYiu/django-cors-headers";
    changelog = "https://github.com/adamchainz/django-cors-headers/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
