{ lib
, buildPythonPackage
, fetchPypi
, django
, memcached
, txamqp
, django_tagging
, gunicorn
, pytz
, pyparsing
, cairocffi
, whisper
, whitenoise
, urllib3
, six
}:

buildPythonPackage rec {
  pname = "graphite-web";
  version = "1.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3cb3b9affe1b9e3777aab046416b3d545390ceea4d35d55c753b1e4732eaad0";
  };

  patches = [
    ./update-django-tagging.patch
  ];

  propagatedBuildInputs = [
    django
    memcached
    txamqp
    django_tagging
    gunicorn
    pytz
    pyparsing
    cairocffi
    whisper
    whitenoise
    urllib3
    six
  ];

  # Carbon-s default installation is /opt/graphite. This env variable ensures
  # carbon is installed as a regular python module.
  GRAPHITE_NO_PREFIX="True";

  preConfigure = ''
    substituteInPlace webapp/graphite/settings.py \
      --replace "join(WEBAPP_DIR, 'content')" "join('$out', 'webapp', 'content')"
  '';

  pythonImportsCheck = [ "graphite" ];

  meta = with lib; {
    homepage = "http://graphiteapp.org/";
    description = "Enterprise scalable realtime graphing";
    maintainers = with maintainers; [ offline basvandijk ];
    license = licenses.asl20;
  };
}
