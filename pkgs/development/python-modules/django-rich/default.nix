{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  # dependencies
  django,
  rich,

  # tests
  coverage,
  pytest-django,
  pytest-randomly,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-rich";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "django-rich";
    tag = finalAttrs.version;
    hash = "sha256-Nd787s55ozqiSGdU8/2S3xbPF0rJuLTyvGqs8Fhu3n8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    rich
  ];

  nativeCheckInputs = [
    coverage
    pytest-django
    pytest-randomly
    pytestCheckHook
  ];

  pythonImportsCheck = [ "django_rich" ];

  meta = {
    description = "Extensions for using Rich with Django";
    homepage = "https://github.com/adamchainz/django-rich";
    changelog = "https://github.com/adamchainz/django-rich/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kilyanni ];
  };
})
