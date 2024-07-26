{ lib
, buildPythonPackage
, fetchFromGitLab
, poetry-core
, djangorestframework
, fido2
, pyotp
, user-agents
}:

buildPythonPackage rec {
  pname = "django-rest-mfa";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "burke-software";
    repo = "django-rest-mfa";
    rev = "v${version}";
    hash = "sha256-qXPHoV567adcSyeCuEvgvZJ+cZhDqq4WV2QSNoKcX88=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    djangorestframework
    fido2
    pyotp
    user-agents
  ];

  pythonImportsCheck = [ "django_rest_mfa" ];

  meta = {
    description = "OTP and FIDO2 multi-factor authentication endpoints built with Django Rest Framework";
    homepage = "https://gitlab.com/burke-software/django-rest-mfa";
    changelog = "https://gitlab.com/burke-software/django-rest-mfa/-/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
}
