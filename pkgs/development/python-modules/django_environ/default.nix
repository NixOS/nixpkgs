{ lib
, buildPythonPackage
, fetchPypi
, django
, six
}:

buildPythonPackage rec {
  pname = "django-environ";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b99bd3704221f8b717c8517d8146e53fdee509d9e99056be560060003b92213e";
  };

  # The testsuite fails to modify the base environment
  doCheck = false;
  propagatedBuildInputs = [ django six ];

  meta = with lib; {
    description = "Utilize environment variables to configure your Django application";
    homepage = "https://github.com/joke2k/django-environ/";
    license = licenses.mit;
  };

}
