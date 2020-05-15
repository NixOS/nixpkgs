{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, django, django_tagging, whisper, pycairo, cairocffi, ldap, memcached, pytz, urllib3, scandir
}:
buildPythonPackage rec {
  pname = "graphite-web";
  version = "1.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4c293008ad588456397cd125cdad7f47f4bab5b6dd82b5fb69f5467e7346a2a";
  };

  patches = [
    ./update-django-tagging.patch
  ];

  propagatedBuildInputs = [
    django django_tagging whisper pycairo cairocffi
    ldap memcached pytz urllib3 scandir
  ];

  # Carbon-s default installation is /opt/graphite. This env variable ensures
  # carbon is installed as a regular python module.
  GRAPHITE_NO_PREFIX="True";

  preConfigure = ''
    substituteInPlace webapp/graphite/settings.py \
      --replace "join(WEBAPP_DIR, 'content')" "join('$out', 'webapp', 'content')"
  '';

  meta = with stdenv.lib; {
    homepage = "http://graphiteapp.org/";
    description = "Enterprise scalable realtime graphing";
    maintainers = with maintainers; [ offline basvandijk ];
    license = licenses.asl20;
  };
}
