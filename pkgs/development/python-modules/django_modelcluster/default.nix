{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, django-taggit
, pytz
, pythonOlder
, python
}:

buildPythonPackage rec {
  pname = "django-modelcluster";
  version = "6.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "wagtail";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-p6hvOkPWRVJYLHvwyn9nS05wblikRFmlSYZuLiCcuqc=";
  };

  propagatedBuildInputs = [
    django
    pytz
  ];

  passthru.optional-dependencies.taggit = [
    django-taggit
  ];

  checkInputs = passthru.optional-dependencies.taggit;

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} ./runtests.py --noinput
    runHook postCheck
  '';

  meta = with lib; {
    description = "Django extension to allow working with 'clusters' of models as a single unit, independently of the database";
    homepage = "https://github.com/torchbox/django-modelcluster/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };

}
