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

buildPythonPackage (finalAttrs: {
  pname = "django-settings-holder";
  version = "0.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MrThearMan";
    repo = "django-settings-holder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tB9V7kVIO7YeaXFfjaUF3YpTRLs/co+lsU/Q9W33v8o=";
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
    changelog = "https://github.com/MrThearMan/django-settings-holder/releases/tag/v${finalAttrs.version}";
    description = "Object that allows settings to be accessed with attributes";
    homepage = "https://github.com/MrThearMan/django-settings-holder";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
