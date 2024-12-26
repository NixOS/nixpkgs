{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pythonOlder,
  pytestCheckHook,
  setuptools,
  pytest-django,
  django-cms,
  djangocms-admin-style,
}:

buildPythonPackage rec {
  pname = "djangocms-admin-style";
  version = "3.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "django-cms";
    repo = "djangocms-admin-style";
    rev = "refs/tags/${version}";
    hash = "sha256-cDbmC7IJTT3NuVXBnbUVqC7dUfusMdntDGu2tSvxIdQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  checkInputs = [ django-cms ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE="tests.settings"
  '';

  disabledTests = [
    # django.template.exceptions.TemplateDoesNotExist: admin/inc/cms_upgrade_notification.html
    "test_render_update_notification"
    # AssertionError: 'my site' != 'example.com'
    "test_current_site_name"
    # django.core.exceptions.ImproperlyConfigured: settings.DATABASES is improperly configured
    "test_render_update_notification"
    "test_current_site_name"
    "test_for_missing_migrations"
  ];

  # Tests depend on django-cms which depends on this package.
  # To avoid infinite recursion, we only enable tests when building passthru.tests.
  doCheck = false;

  passthru.tests = {
    runTests = djangocms-admin-style.overridePythonAttrs (_: {
      doCheck = true;
    });
  };

  pythonImportsCheck = [ "djangocms_admin_style" ];

  meta = {
    description = "Django Theme tailored to the needs of django CMS";
    homepage = "https://django-cms.org";
    changelog = "https://github.com/django-cms/djangocms-admin-style/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.onny ];
  };
}
