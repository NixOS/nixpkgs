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
  pname = "django-htmx";
  version = "1.24.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "django-htmx";
    rev = version;
    hash = "sha256-pxCC/LTvk2bKARb+eOCQgspp7WibnWdIvgUPf+yYRyw=";
  };

  build-system = [ setuptools ];

  buildInputs = [ django ];

  dependencies = [ asgiref ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  pythonImportsCheck = [ "django_htmx" ];

  meta = {
    description = "Extensions for using Django with htmx";
    homepage = "https://github.com/adamchainz/django-htmx";
    changelog = "https://github.com/adamchainz/django-htmx/blob/${version}/docs/changelog.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ minijackson ];
  };
}
