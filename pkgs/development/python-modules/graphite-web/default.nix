{ lib
, stdenv
, buildPythonPackage
, python
, cairocffi
, django
, django-tagging
, fetchFromGitHub
, fetchpatch
, gunicorn
, mock
, pyparsing
, python-memcached
, pythonOlder
, pytz
, six
, txamqp
, urllib3
, whisper
}:

buildPythonPackage rec {
  pname = "graphite-web";
  version = "1.1.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "graphite-project";
    repo = pname;
    rev = version;
    hash = "sha256-2HgCBKwLfxJLKMopoIdsEW5k/j3kNAiifWDnJ98a7Qo=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-4730.CVE-2022-4729.CVE-2022-4728.part-1.patch";
      url = "https://github.com/graphite-project/graphite-web/commit/9c626006eea36a9fd785e8f811359aebc9774970.patch";
      hash = "sha256-JMmdhLqsaRhUG2FsH+yPNl+cR7O2YLfKFliL2GU0aAk=";
    })
    (fetchpatch {
      name = "CVE-2022-4730.CVE-2022-4729.CVE-2022-4728.part-2.patch";
      url = "https://github.com/graphite-project/graphite-web/commit/2f178f490e10efc03cd1d27c72f64ecab224eb23.patch";
      hash = "sha256-NL7K5uekf3NlLa58aFFRPJT9ktjqBeNlWC4Htd0fRQ0=";
    })
  ];

  propagatedBuildInputs = [
    cairocffi
    django
    django-tagging
    gunicorn
    pyparsing
    python-memcached
    pytz
    six
    txamqp
    urllib3
    whisper
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "Django>=1.8,<3.1" "Django" \
      --replace "django-tagging==0.4.3" "django-tagging"
  '';

  # Carbon-s default installation is /opt/graphite. This env variable ensures
  # carbon is installed as a regular Python module.
  GRAPHITE_NO_PREFIX = "True";

  preConfigure = ''
    substituteInPlace webapp/graphite/settings.py \
      --replace "join(WEBAPP_DIR, 'content')" "join('$out', 'webapp', 'content')"
  '';

  checkInputs = [ mock ];
  checkPhase = ''
    runHook preCheck

    pushd webapp/
    # avoid confusion with installed module
    rm -r graphite
    # redis not practical in test environment
    substituteInPlace tests/test_tags.py \
      --replace test_redis_tagdb _dont_test_redis_tagdb

    DJANGO_SETTINGS_MODULE=tests.settings ${python.interpreter} manage.py test
    popd

    runHook postCheck
  '';

  pythonImportsCheck = [
    "graphite"
  ];

  meta = with lib; {
    description = "Enterprise scalable realtime graphing";
    homepage = "http://graphiteapp.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline basvandijk ];
  };
}
