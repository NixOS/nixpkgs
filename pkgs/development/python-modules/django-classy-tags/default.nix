{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-classy-tags";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-cms";
    repo = "django-classy-tags";
    tag = finalAttrs.version;
    hash = "sha256-JC8z3Y39hYUXCrnN+Bi3w5DYhPGegloLo9LZfe0MtIM=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  pythonImportsCheck = [ "classytags" ];

  meta = {
    description = "Class based template tags for Django";
    homepage = "https://django-classy-tags.readthedocs.io";
    changelog = "https://github.com/django-cms/django-classy-tags/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
