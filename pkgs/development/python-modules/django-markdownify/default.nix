{
  buildPythonPackage,
  django,
  fetchFromGitHub,
  lib,
  pytest-django,
  pytestCheckHook,
  setuptools,
  markdown,
  bleach,
  tinycss2,
}:
buildPythonPackage (finalAttrs: {
  pname = "django-markdownify";
  version = "0.9.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erwinmatijsen";
    repo = "django-markdownify";
    tag = finalAttrs.version;
    hash = "sha256-L/N0jjxBz7aQletOg+qairgq4utifPz4oqjT9AcljLI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    markdown
    bleach
  ]
  ++ bleach.optional-dependencies.css;

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=markdownify.checks
  '';

  nativeCheckInputs = [
    tinycss2
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "markdownify" ];

  disabledTests = [
    # Test settings didn't setup DjangoTemplates
    "test_markdownify_nodelist"
  ];

  meta = {
    description = "Markdown template filter for Django";
    homepage = "https://github.com/erwinmatijsen/django-markdownify";
    changelog = "https://github.com/erwinmatijsen/django-markdownify/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kurogeek ];
  };
})
