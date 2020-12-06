{ stdenv, buildPythonPackage, fetchPypi
, django_environ, mock, django
, pytest, pytestrunner, pytest-django
}:
buildPythonPackage rec {
  pname = "django-guardian";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed2de26e4defb800919c5749fb1bbe370d72829fbd72895b6cf4f7f1a7607e1b";
  };

  checkInputs = [ pytest pytestrunner pytest-django django_environ mock ];
  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "Per object permissions for Django";
    homepage = "https://github.com/django-guardian/django-guardian";
    license = [ licenses.mit licenses.bsd2 ];
  };
}
