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
buildPythonPackage rec {
  pname = "django-markdownify";
  version = "0.9.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erwinmatijsen";
    repo = "django-markdownify";
    tag = version;
    hash = "sha256-KYU8p8NRD4EIS/KhOk9nvmXCf0RWEc+IFZ57YtsDSWE=";
  };

  dependencies = [
    django
    markdown
    bleach
  ];

  build-system = [ setuptools ];
  doCheck = true;
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

  meta = with lib; {
    description = "Markdown template filter for Django";
    homepage = "https://github.com/erwinmatijsen/django-markdownify";
    license = licenses.mit;
    maintainers = with maintainers; [ kurogeek ];
  };
}
