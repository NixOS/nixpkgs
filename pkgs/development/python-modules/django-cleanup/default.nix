{ stdenv, buildPythonPackage, fetchPypi, django
, redis, async-timeout, hiredis
}:

buildPythonPackage rec {
  pname = "django-cleanup";
  version = "4.0.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "4d0fd9ad3117a219e4cb3e35dd32f39c764a860ce56b820abb88ad3ec063ffd7";
  };

  checkInputs = [ django ];

  meta = with stdenv.lib; {
    description = "Automatically deletes old file for FileField and ImageField. It also deletes files on models instance deletion";
    homepage = "https://github.com/un1t/django-cleanup";
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}
