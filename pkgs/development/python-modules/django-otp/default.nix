{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, hatchling
, django
, freezegun
, pythonOlder
, qrcode
}:

buildPythonPackage rec {
  pname = "django-otp";
  version = "1.3.0";
  format = "pyproject";
  disabled = pythonOlder "3";

  src = fetchFromGitHub {
    owner = "django-otp";
    repo = "django-otp";
    rev = "v${version}";
    hash = "sha256-T9sAKAjH8ZbfxYzRKgTDoAlZ/+uLj2R/T/ZHXhtjjVk=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    django
    qrcode
  ];

  nativeCheckInputs = [
    django
    freezegun
  ];

  checkPhase = ''
    export PYTHONPATH="test:$PYTHONPATH"
    export DJANGO_SETTINGS_MODULE="test_project.settings"
    ${python.interpreter} -s -m django test django_otp
  '';

  pythonImportsCheck = [ "django_otp" ];

  meta = with lib; {
    homepage = "https://github.com/django-otp/django-otp/";
    description = "Pluggable framework for adding two-factor authentication to Django using one-time passwords";
    license = licenses.unlicense;
    maintainers = with maintainers; [ ];
  };
}
