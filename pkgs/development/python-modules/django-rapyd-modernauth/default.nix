{ lib
, buildPythonPackage
, fetchFromGitHub
, asgiref
, django
, python
, python-dotenv
, pytz
, setuptools
, sqlparse
, zipp
}:

buildPythonPackage rec {
  pname = "django-rapyd-modernauth";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "karthicraghupathi";
    repo = "django_rapyd_modernauth";
    rev = "v${version}";
    hash = "sha256-9IIW6Xsaj2+/SR2CIX4fnUHlAehmLulpBAC7YB3ZrZE=";
  };

  checkPhase = ''
    runHook preCheck

    echo 'LOG_LEVEL="INFO"' > .env
    echo DJANGO_SECRET_KEY="$(base64 /dev/urandom | head -c50)" >> .env
    ${python.interpreter} ./testrunner.py

    runHook postCheck
  '';

  propagatedBuildInputs = [
    asgiref
    django
    python-dotenv
    pytz
    setuptools
    sqlparse
    zipp
  ];

  pythonImportsCheck = [
    "modernauth"
  ];

  meta = with lib; {
    description = "A Django application that provides a custom User model where the username is the email address.";
    homepage = "https://github.com/karthicraghupathi/django_rapyd_modernauth";
    license = licenses.afl20;
    maintainers = [ maintainers.greg ];
  };
}
