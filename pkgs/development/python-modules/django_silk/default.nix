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
  version = "4.1.0";

  # pypi tarball doesn't include test project
  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-silk";
    rev = version;
    sha256 = "1km3hmx1sir0c5gqr2p1h2938slhxp2hzf10cb80q98mas8spjkn";
  };

  patches = lib.optional (pythonAtLeast "3.9") (fetchpatch {
    # should be able to remove after 4.1.1
    name = "python-3.9-support.patch";
    url = "https://github.com/jazzband/django-silk/commit/134089e4cad7bd3b76fb0f70c423082cb7d2b34a.patch";
    sha256 = "09c1xd9y33h3ibiv5w9af9d79c909rgc1g5sxpd4y232h5id3c8r";
  });

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
    cd project
    DB=sqlite3 DB_NAME=db.sqlite3 ${python.interpreter} manage.py test
  '';

  meta = with lib; {
    description = "Silky smooth profiling for the Django Framework";
    homepage = "https://github.com/jazzband/django-silk";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };

}
