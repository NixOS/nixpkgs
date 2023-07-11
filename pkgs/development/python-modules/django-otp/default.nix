{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, freezegun
, pythonOlder
, qrcode
}:

buildPythonPackage rec {
  pname = "django-otp";
  version = "1.1.3";
  disabled = pythonOlder "3";

  src = fetchFromGitHub {
    owner = "django-otp";
    repo = "django-otp";
    rev = "v${version}";
    hash = "sha256-Ac9p7q9yaUr3WTTGxCY16Yo/Z8i1RtnD2g0Aj2pqSXY=";
  };

  postPatch = ''
    patchShebangs manage.py
  '';

  propagatedBuildInputs = [
    django
    qrcode
  ];

  nativeCheckInputs = [
    freezegun
  ];

  checkPhase = ''
    ./manage.py test django_otp
  '';

  pythonImportsCheck = [ "django_otp" ];

  meta = with lib; {
    homepage = "https://github.com/jazzband/django-model-utils";
    description = "Pluggable framework for adding two-factor authentication to Django using one-time passwords";
    license = licenses.bsd2;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
