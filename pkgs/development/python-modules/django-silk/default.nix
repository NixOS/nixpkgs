{
  lib,
  autopep8,
  buildPythonPackage,
  django,
  factory-boy,
  fetchFromGitHub,
  freezegun,
  gprof2dot,
  jinja2,
  mock,
  networkx,
  pillow,
  pydot,
  pygments,
  python,
  python-dateutil,
  pythonOlder,
  pytz,
  requests,
  setuptools-scm,
  simplejson,
  sqlparse,
}:

buildPythonPackage rec {
  pname = "django-silk";
  version = "5.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-silk";
    tag = version;
    hash = "sha256-Rm3iyEFphhDYGC7fQy+RUrbAOQQSOSiu+bOcp7TozN0=";
  };

  # "test_time_taken" tests aren't suitable for reproducible execution, but Django's
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
    autopep8
    django
    gprof2dot
    jinja2
    pillow
    pygments
    python-dateutil
    pytz
    requests
    simplejson
    sqlparse
  ];

  nativeCheckInputs = [
    freezegun
    networkx
    pydot
    factory-boy
  ];

  pythonImportsCheck = [ "silk" ];

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
    changelog = "https://github.com/jazzband/django-silk/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
