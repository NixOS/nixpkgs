{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  django,
  django-otp,
  webauthn,
  pytestCheckHook,
  beautifulsoup4,
  dj-database-url,
  django-csp,
  django-debug-toolbar,
  jsonschema,
  pytest-django,
  pytest-factoryboy,
  pytest-mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-otp-webauthn";
  version = "0.10.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Stormbase";
    repo = "django-otp-webauthn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BmbCC0Tf4Ghp/bjRc2q5efRx3MWR8tARiT4iMq51jP0=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    django
    django-otp
    webauthn
  ];

  pythonImportsCheck = [ "django_otp_webauthn" ];

  nativeCheckInputs = [
    pytestCheckHook
    beautifulsoup4
    dj-database-url
    django-csp
    django-debug-toolbar
    jsonschema
    pytest-django
    pytest-factoryboy
    pytest-mock
  ];

  meta = {
    description = "Passkey support for Django";
    homepage = "https://github.com/Stormbase/django-otp-webauthn";
    changelog = "https://github.com/Stormbase/django-otp-webauthn/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ erictapen ];
  };

})
