{ lib
, stdenv
, buildPythonPackage
, cairocffi
, django
, django_tagging
, fetchFromGitHub
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
