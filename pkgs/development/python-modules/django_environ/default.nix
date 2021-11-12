{ lib
, buildPythonPackage
, fetchPypi
, django
, six
}:

buildPythonPackage rec {
  pname = "django-environ";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f0bc902b43891656b20486938cba0861dc62892784a44919170719572a534cb";
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
