{ lib
, buildPythonPackage
, fetchPypi
, django
, six
}:

buildPythonPackage rec {
  pname = "django-environ";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a8726675c1ebefa4706b36398c4d3c5c790d335ffe55c4a10378f6bfd57ad8d0";
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
