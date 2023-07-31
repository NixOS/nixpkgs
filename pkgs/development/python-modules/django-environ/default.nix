{ lib
, buildPythonPackage
, fetchPypi
, django
, six
}:

buildPythonPackage rec {
  pname = "django-environ";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v/U4FTMFYyjJrAL3F5C9W/HOqBsb7rZI8ouByeg+CiE=";
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
