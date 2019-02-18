{ stdenv
, buildPythonPackage
, fetchPypi
, django
, six
}:

buildPythonPackage rec {
  pname = "django-environ";
  version = "0.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c9d87660142608f63ec7d5ce5564c49b603ea8ff25da595fd6098f6dc82afde";
  };

  # The testsuite fails to modify the base environment
  doCheck = false;
  propagatedBuildInputs = [ django six ];

  meta = with stdenv.lib; {
    description = "Utilize environment variables to configure your Django application";
    homepage = https://github.com/joke2k/django-environ/;
    license = licenses.mit;
  };

}
