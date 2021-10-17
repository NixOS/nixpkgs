{ lib
, buildPythonPackage
, fetchPypi
, django
, six
}:

buildPythonPackage rec {
  pname = "django-environ";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f77f8890d4cdaf53c3f233bc4367c219d3e8f15073959f8decffc72fd64321c2";
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
