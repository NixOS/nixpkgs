{ stdenv, buildPythonPackage, fetchPypi, django
, redis, async-timeout, hiredis
}:

buildPythonPackage rec {
  pname = "django-cleanup";
  version = "5.0.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "84f0c0e0a74545adae4c944a76ccf8fb0c195dddccf3b7195c59267abb7763dd";
  };

  checkInputs = [ django ];

  meta = with stdenv.lib; {
    description = "Automatically deletes old file for FileField and ImageField. It also deletes files on models instance deletion";
    homepage = "https://github.com/un1t/django-cleanup";
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}
