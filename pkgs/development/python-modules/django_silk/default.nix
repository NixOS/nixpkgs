{ lib
, buildPythonPackage
, python
, pythonAtLeast
, fetchFromGitHub
, fetchpatch
, django
, pygments
, simplejson
, python-dateutil
, requests
, setuptools-scm
, sqlparse
, jinja2
, autopep8
, pytz
, pillow
, mock
, gprof2dot
, freezegun
, contextlib2
, networkx
, pydot
, factory_boy
}:

buildPythonPackage rec {
  pname = "django-silk";
  version = "5.0.1";

  # pypi tarball doesn't include test project
  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-silk";
    rev = version;
    hash = "sha256-U2lj0B85cf2xu0o7enuLJB5YKaIt6gMvn+TgxleLslk=";
  };

  # "test_time_taken" tests aren't suitable for reproducible execution, but django's
  # test runner doesn't have an easy way to ignore tests - so instead prevent it from picking
  # them up as tests
  postPatch = ''
    substituteInPlace project/tests/test_silky_profiler.py \
      --replace "def test_time_taken" "def _test_time_taken"
    substituteInPlace setup.py \
      --replace 'use_scm_version=True' 'version="${version}"'
  '';

  nativeBuildInputs = [ setuptools-scm ];
  buildInputs = [ mock ];
  propagatedBuildInputs = [
    django pygments simplejson python-dateutil requests
    sqlparse jinja2 autopep8 pytz pillow gprof2dot
  ];

  checkInputs = [ freezegun contextlib2 networkx pydot factory_boy ];
  checkPhase = ''
    runHook preCheck

    pushd project
    DB_ENGINE=sqlite3 DB_NAME=':memory:' ${python.interpreter} manage.py test
    popd # project

    runHook postCheck
  '';

  meta = with lib; {
    description = "Silky smooth profiling for the Django Framework";
    homepage = "https://github.com/jazzband/django-silk";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };

}
