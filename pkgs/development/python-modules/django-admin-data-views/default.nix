{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  django,
  django-settings-holder,
  pytestCheckHook,
  pytest-django,
  freezegun,
  beautifulsoup4,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-admin-data-views";
  version = "0.4.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MrThearMan";
    repo = "django-admin-data-views";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sHiocm5clvVMKSRYUfb6UlWdLud+9aeCHRYIDOW3BUY=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    django
    django-settings-holder
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    freezegun
    beautifulsoup4
  ];

  pythonImportsCheck = [ "admin_data_views" ];

  meta = {
    changelog = "https://github.com/MrThearMan/django-admin-data-views/releases/tag/v${finalAttrs.version}";
    description = "Add custom data views to Django admin panel";
    homepage = "https://github.com/MrThearMan/django-admin-data-views";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
