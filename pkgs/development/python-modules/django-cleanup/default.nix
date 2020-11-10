{ stdenv, buildPythonPackage, fetchPypi, django
, redis, async-timeout, hiredis
}:

buildPythonPackage rec {
  pname = "django-cleanup";
  version = "5.1.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "8976aec12a22913afb3d1fcb541b1aedde2f5ec243e4260c5ff78bb6aa75a089";
  };

  checkInputs = [ django ];

  meta = with stdenv.lib; {
    description = "Automatically deletes old file for FileField and ImageField. It also deletes files on models instance deletion";
    homepage = "https://github.com/un1t/django-cleanup";
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}
