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
  version = "0.11.0a5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Stormbase";
    repo = "django-otp-webauthn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1CbgBiBH+lMaD6LhqWLNV/JMxCCZQ1o+g7OlEtN0nOE=";
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
