{ lib, buildPythonPackage, fetchPypi
, django_environ, mock, django
, pytest, pytest-runner, pytest-django
}:
buildPythonPackage rec {
  pname = "django-guardian";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c58a68ae76922d33e6bdc0e69af1892097838de56e93e78a8361090bcd9f89a0";
  };

  checkInputs = [ pytest pytest-runner pytest-django django_environ mock ];
  propagatedBuildInputs = [ django ];

  meta = with lib; {
    description = "Per object permissions for Django";
    homepage = "https://github.com/django-guardian/django-guardian";
    license = [ licenses.mit licenses.bsd2 ];
  };
}
