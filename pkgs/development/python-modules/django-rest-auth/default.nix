{ lib,
  fetchPypi,
  django,
  djangorestframework,
  six,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "django-rest-auth";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad155a0ed1061b32e3e46c9b25686e397644fd6acfd35d5c03bc6b9d2fc6c82a";
  };

  propagatedBuildInputs = [ django djangorestframework six ];

  # pypi release does not include tests
  doCheck = false;

  meta = with lib; {
    description = "Django app that makes registration and authentication easy";
    homepage = https://github.com/Tivix/django-rest-auth;
    license = licenses.mit;
    maintainers = [ maintainers.ivegotasthma ];
  };
}
