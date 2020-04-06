{ stdenv, buildPythonPackage, fetchPypi, django
, redis, async-timeout, hiredis
}:

buildPythonPackage rec {
  pname = "django-cleanup";
  version = "4.0.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "195hkany3iwg4wb4cbdrdmanxcahjl87n8v03dbamanx2ya3yb21";
  };

  checkInputs = [ django ];

  meta = with stdenv.lib; {
    description = "Automatically deletes old file for FileField and ImageField. It also deletes files on models instance deletion";
    homepage = https://github.com/un1t/django-cleanup;
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}
