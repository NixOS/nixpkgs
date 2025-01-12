{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  rich,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-rich";
  version = "1.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "django-rich";
    rev = "refs/tags/${version}";
    hash = "sha256-2Pf40+SxjaG9h4clrscnGOmyXoJLJGWM02iw1SdaQpE=";
  };

  postPatch = ''
    # Disable coverage testing
    echo "" > tests/testapp/__init__.py
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    django
    rich
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  pythonImportsCheck = [ "django_rich" ];

  meta = {
    changelog = "https://github.com/adamchainz/django-rich/blob/${version}/CHANGELOG.rst";
    description = "Extensions for using Rich with Django";
    homepage = "https://github.com/adamchainz/django-rich";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
