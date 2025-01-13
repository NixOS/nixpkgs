{
  lib,
  buildPythonPackage,
  python,
  cairocffi,
  django,
  django-tagging,
  fetchFromGitHub,
  gunicorn,
  mock,
  pyparsing,
  python-memcached,
  pythonOlder,
  pytz,
  six,
  txamqp,
  urllib3,
  whisper,
  nixosTests,
}:

buildPythonPackage rec {
  pname = "graphite-web";
  version = "1.1.10-unstable-2024-10-21";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "graphite-project";
    repo = pname;
    rev = "55adbb6fd80a3dcd089a2c4458c71af01f191c9b";
    hash = "sha256-f2EmYtaUCehyQ0HdxceT/DonwsrIJMCWToGcUcdsEyI=";
  };

  dependencies = [
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
       --replace-fail "Django>=3.2,<4" "Django"
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
      --replace-fail test_redis_tagdb _dont_test_redis_tagdb

    DJANGO_SETTINGS_MODULE=tests.settings ${python.interpreter} manage.py test
    popd

    runHook postCheck
  '';

  pythonImportsCheck = [ "graphite" ];

  passthru.tests = {
    inherit (nixosTests) graphite;
  };

  meta = with lib; {
    description = "Enterprise scalable realtime graphing";
    homepage = "http://graphiteapp.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [
      offline
      basvandijk
    ];
  };
}
