{ lib
, stdenv
, buildPythonPackage
, cairocffi
, django
, django_tagging
, fetchFromGitHub
, fetchpatch
, gunicorn
, pyparsing
, python-memcached
, pythonOlder
, pytz
, six
, txamqp
, urllib3
, whisper
, whitenoise
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
      sha256 = "sha256-JMmdhLqsaRhUG2FsH+yPNl+cR7O2YLfKFliL2GU0aAk=";
    })
    (fetchpatch {
      name = "CVE-2022-4730.CVE-2022-4729.CVE-2022-4728.part-2.patch";
      url = "https://github.com/graphite-project/graphite-web/commit/2f178f490e10efc03cd1d27c72f64ecab224eb23.patch";
      sha256 = "sha256-NL7K5uekf3NlLa58aFFRPJT9ktjqBeNlWC4Htd0fRQ0=";
    })
  ];

  propagatedBuildInputs = [
    cairocffi
    django
    django_tagging
    gunicorn
    pyparsing
    python-memcached
    pytz
    six
    txamqp
    urllib3
    whisper
    whitenoise
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

  pythonImportsCheck = [
    "graphite"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Enterprise scalable realtime graphing";
    homepage = "http://graphiteapp.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline basvandijk ];
  };
}
