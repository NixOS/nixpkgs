{ stdenv, buildPythonPackage, fetchPypi
, django_environ, mock, django
, pytest, pytestrunner, pytest-django
}:
buildPythonPackage rec {
  pname = "django-guardian";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8cf4efd67a863eb32beafd4335a38ffb083630f8ab2045212d27f8f9c3abe5a6";
  };

  checkInputs = [ pytest pytestrunner pytest-django django_environ mock ];
  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "Per object permissions for Django";
    homepage = https://github.com/django-guardian/django-guardian;
    license = [ licenses.mit licenses.bsd2 ];
  };
}
