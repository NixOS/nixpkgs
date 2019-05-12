{ stdenv, buildPythonPackage, fetchPypi
, django_environ, mock, django, six
, pytest, pytestrunner, pytest-django
}:
buildPythonPackage rec {
  pname = "django-guardian";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fixr2g5amdgqzh0rvfvd7hbxyfd5ra3y3s0fsmp8i1b68p97930";
  };

  checkInputs = [ pytest pytestrunner pytest-django django_environ mock ];
  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "Per object permissions for Django";
    homepage = https://github.com/django-guardian/django-guardian;
    license = [ licenses.mit licenses.bsd2 ];
  };
}
