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

buildPythonPackage rec {
  pname = "django-admin-data-views";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MrThearMan";
    repo = "django-admin-data-views";
    rev = "refs/tags/v${version}";
    hash = "sha256-+QfIibqN6+TnEDcnMwvEePi7BpX+g7JXmczdWxEjzzE=";
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
    changelog = "https://github.com/MrThearMan/django-admin-data-views/releases/tag/v${version}";
    description = "Add custom data views to django admin panel";
    homepage = "https://github.com/MrThearMan/django-admin-data-views";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
