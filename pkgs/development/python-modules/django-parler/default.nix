{ lib
, buildPythonPackage
, django
, fetchFromGitHub
, pytest
, pytest-django
, pythonOlder
, python
}:

buildPythonPackage rec {
  pname = "django-parler";
  version = "2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "django-parler";
    repo = "django-parler";
    rev = "refs/tags/v${version}";
    hash = "sha256-tRGifFPCXF3aa3PQWKw3tl1H1TY+lgcChUP1VdwG1cE=";
  };

  propagatedBuildInputs = [
    django
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} runtests.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Simple Django model translations without nasty hacks";
    homepage = "https://github.com/django-parler/django-parler";
    changelog = "https://github.com/django-parler/django-parler/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ derdennisop ];
  };
}
