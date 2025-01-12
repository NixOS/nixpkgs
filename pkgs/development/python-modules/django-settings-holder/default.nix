{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  django,
  pytestCheckHook,
  pytest-django,
  freezegun,
}:

buildPythonPackage rec {
  pname = "django-settings-holder";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MrThearMan";
    repo = "django-settings-holder";
    rev = "refs/tags/v${version}";
    hash = "sha256-9mvoCZDjZ5/3NtWXXzfCyuKJcIwnSHCt7UBh093OjoU=";
  };

  build-system = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
    django
    pytest-django
    freezegun
  ];

  pythonImportsCheck = [ "settings_holder" ];

  meta = {
    changelog = "https://github.com/MrThearMan/django-settings-holder/releases/tag/v${version}";
    description = "Object that allows settings to be accessed with attributes";
    homepage = "https://github.com/MrThearMan/django-settings-holder";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
