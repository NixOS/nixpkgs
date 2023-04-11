{ lib
, buildPythonPackage
, django
, django-formtools
, django-otp
, django-phonenumber-field
, fetchFromGitHub
, pydantic
, pythonOlder
, pythonRelaxDepsHook
, qrcode
, setuptools-scm
, twilio
, webauthn
}:

buildPythonPackage rec {
  pname = "django-two-factor-auth";
  version = "1.15.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-two-factor-auth";
    rev = "refs/tags/${version}";
    hash = "sha256-+E6kSD00ChPiRLT2i43dNlVkbvuR1vKkbSZfD1Bf3qc=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "django-phonenumber-field"
  ];

  propagatedBuildInputs = [
    django
    django-formtools
    django-otp
    # django-otp-yubikey #Addtional Pkgs not in nixpkgs yet
    django-phonenumber-field
    pydantic
    qrcode
    twilio
    webauthn
  ];

  # require internet connection
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
