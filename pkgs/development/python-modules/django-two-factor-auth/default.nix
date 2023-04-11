{ lib
, buildPythonPackage
, django
, django-formtools
, django-otp
, django-phonenumber-field
, fetchFromGitHub
, pythonOlder
, qrcode
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "django-payments";
  version = "1.15.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-two-factor-auth";
    rev = "refs/tags/${version}";
    hash = "sha256-+E6kSD00ChPiRLT2i43dNlVkbvuR1vKkbSZfD1Bf3qc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "django-phonenumber-field>=1.1.0,<7" "django-phonenumber-field"
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
    django-formtools
    django-otp
    django-phonenumber-field
    qrcode
  ];

  # require internet connection
  doCheck = false;

  meta = with lib; {
    description = "Complete Two-Factor Authentication for Django.";
    homepage = "https://github.com/jazzband/django-two-factor-auth/";
    changelog = "https://github.com/jazzband/django-two-factor-auth/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
