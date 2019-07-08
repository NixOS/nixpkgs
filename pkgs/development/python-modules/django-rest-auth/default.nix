{ lib,
  fetchPypi,
  django,
  djangorestframework,
  six,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "django-rest-auth";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f11e12175dafeed772f50d740d22caeab27e99a3caca24ec65e66a8d6de16571";
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
