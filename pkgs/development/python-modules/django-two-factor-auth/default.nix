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
  qrcode,
  setuptools-scm,
  twilio,
  webauthn,
}:

buildPythonPackage rec {
  pname = "django-two-factor-auth";
  version = "1.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-two-factor-auth";
    tag = version;
    hash = "sha256-gg5QpPQbYnQr7KkCXFZ9Gnz48Cf4Nm67uV6JuyxK18c=";
  };

  build-system = [ setuptools-scm ];

  pythonRelaxDeps = [
    "django-phonenumber-field"
    "qrcode"
  ];

  dependencies = [
    django
    django-formtools
    django-otp
    django-phonenumber-field
    qrcode
  ];

  optional-dependencies = {
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

  meta = {
    description = "Complete Two-Factor Authentication for Django";
    homepage = "https://github.com/jazzband/django-two-factor-auth";
    changelog = "https://github.com/jazzband/django-two-factor-auth/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
