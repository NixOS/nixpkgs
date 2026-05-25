{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-django,
  pytestCheckHook,
  setuptools-scm,
  pillow,
  pytest-cov-stub,
  django,
  gettext,
}:
buildPythonPackage (finalAttrs: {
  pname = "django-stdimage";
  version = "6.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "codingjoe";
    repo = "django-stdimage";
    tag = finalAttrs.version;
    hash = "sha256-uwVU3Huc5fitAweShJjcMW//GBeIpJcxqKKLGo/EdIs=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    django
    pillow
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  disabledTestPaths = [
    # These tests failed on Django 5 or later
    "tests/test_commands.py"
    "tests/test_models.py::TestModel::test_variations"
    "tests/test_models.py::TestModel::test_cropping"
    "tests/test_models.py::TestModel::test_custom_render_variations"
    "tests/test_models.py::TestModel::test_defer"
    "tests/test_models.py::TestModel::test_variations_deepcopy"
    "tests/test_models.py::TestUtils::test_render_variations_callback"
    "tests/test_models.py::TestUtils::test_render_variations_overwrite"
    "tests/test_models.py::TestJPEGField::test_convert"
    "tests/test_models.py::TestJPEGField::test_convert_multiple"
  ];

  pythonImportsCheck = [
    "stdimage"
    "stdimage.validators"
    "stdimage.models"
  ];

  nativeCheckInputs = [
    gettext
    pytest-django
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    description = "Django Standardized Image Field";
    homepage = "https://github.com/codingjoe/django-stdimage";
    changelog = "https://github.com/codingjoe/django-stdimage/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kurogeek ];
  };
})
