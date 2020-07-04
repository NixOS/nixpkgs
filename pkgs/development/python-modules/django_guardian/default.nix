{ stdenv, buildPythonPackage, fetchPypi
, django_environ, mock, django
, pytest, pytestrunner, pytest-django
}:
buildPythonPackage rec {
  pname = "django-guardian";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8cacf49ebcc1e545f0a8997971eec0fe109f5ed31fc2a569a7bf5615453696e2";
  };

  checkInputs = [ pytest pytestrunner pytest-django django_environ mock ];
  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "Per object permissions for Django";
    homepage = "https://github.com/django-guardian/django-guardian";
    license = [ licenses.mit licenses.bsd2 ];
  };
}
