{ lib
, buildPythonPackage
, confusable_homoglyphs
, django
, fetchFromGitHub
, python
, setuptools
}:

buildPythonPackage rec {
  pname = "django-registration";
  version = "3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ubernostrum";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-iaJSJxQLAEq3sjc3DmYoTQ+hwTN64s4Idnd/+LiL5kk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    confusable_homoglyphs
    django
  ];

  checkPhase = ''
    runHook preCheck
    DJANGO_SETTINGS_MODULE=tests.settings ${python.interpreter} runtests.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "An extensible user-registration app for Django. ";
    homepage = "https://github.com/ubernostrum/django-registration/tree/trunk";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rogryza ];
  };
}

