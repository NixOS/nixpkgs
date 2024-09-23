{
  lib,
  buildPythonPackage,
  django,
  django-formtools,
  django-otp,
  django-phonenumber-field,
  fetchFromGitHub,
  phonenumbers,
  pydantic,
  pythonOlder,
  qrcode,
  setuptools-scm,
  twilio,
  webauthn,
}:

buildPythonPackage rec {
  pname = "django-two-factor-auth";
  version = "1.15.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-two-factor-auth";
    rev = "refs/tags/${version}";
    hash = "sha256-Sr7L3ioeofyADHb1NSgs0GmVbzX7rro7yhhG9Gq6GJE=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  pythonRelaxDeps = [ "django-phonenumber-field" ];

  propagatedBuildInputs = [
    django
    django-formtools
    django-otp
    django-phonenumber-field
    qrcode
  ];

  passthru.optional-dependencies = {
    call = [ twilio ];
    sms = [ twilio ];
    webauthn = [
      pydantic
      webauthn
    ];
    # yubikey = [
    #   django-otp-yubikey
    # ];
    phonenumbers = [ phonenumbers ];
    # phonenumberslite = [
    #   phonenumberslite
    # ];
  };

  # Tests require internet connection
  doCheck = false;

  pythonImportsCheck = [ "two_factor" ];

  meta = with lib; {
    description = "Complete Two-Factor Authentication for Django";
    homepage = "https://github.com/jazzband/django-two-factor-auth";
    changelog = "https://github.com/jazzband/django-two-factor-auth/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
