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
  version = "1.17.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "Complete Two-Factor Authentication for Django";
    homepage = "https://github.com/jazzband/django-two-factor-auth";
    changelog = "https://github.com/jazzband/django-two-factor-auth/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
