{
  lib,
  buildPythonPackage,
  django,
  django-allauth,
  django-otp,
  fetchFromGitHub,
  pythonOlder,
  qrcode,
  hatchling,
}:

buildPythonPackage rec {
  pname = "django-allauth-2fa";
  version = "0.11.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "valohai";
    repo = "django-allauth-2fa";
    rev = "refs/tags/v${version}";
    hash = "sha256-bm2RwhvX2nfhYs74MM0iZl9U2gHgm0lLlh2tuRRcGso=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    django
    django-allauth
    django-otp
    qrcode
  ];

  pythonImportsCheck = [ "allauth_2fa" ];

  meta = with lib; {
    description = "django-allauth-2fa adds two-factor authentication to django-allauth";
    homepage = "https://github.com/valohai/django-allauth-2fa";
    changelog = "https://github.com/valohai/django-allauth-2fa/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ derdennisop ];
  };
}
