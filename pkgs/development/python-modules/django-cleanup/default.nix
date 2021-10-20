{ lib, buildPythonPackage, fetchPypi, django
, redis, async-timeout, hiredis
}:

buildPythonPackage rec {
  pname = "django-cleanup";
  version = "5.2.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "909d10ff574f5ce1a40fa63bd5c94c9ed866fd7ae770994c46cdf66c3db3e846";
  };

  checkInputs = [ django ];

  meta = with lib; {
    description = "Automatically deletes old file for FileField and ImageField. It also deletes files on models instance deletion";
    homepage = "https://github.com/un1t/django-cleanup";
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}
