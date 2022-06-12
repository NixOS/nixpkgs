{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, django
, python-memcached
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
  version = "1.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "54240b0f1e069b53e2ce92d4e534e21b195fb0ebd64b6ad8a49c44284e3eb0b1";
  };

  patches = [
    ./update-django-tagging.patch
  ];

  postPatch = ''
    # https://github.com/graphite-project/graphite-web/pull/2701
    substituteInPlace setup.py \
      --replace "'scandir'" "'scandir; python_version < \"3.5\"'"
  '';

  propagatedBuildInputs = [
    django
    python-memcached
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
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    homepage = "http://graphiteapp.org/";
    description = "Enterprise scalable realtime graphing";
    maintainers = with maintainers; [ offline basvandijk ];
    license = licenses.asl20;
  };
}
