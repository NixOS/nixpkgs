{ lib
, buildPythonPackage
, fetchPypi
, django
, six
}:

buildPythonPackage rec {
  pname = "django-classy-tags";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0iK0VQKsmeVQpWZmeDnvrvlUucc2amST8UOGKqvqyHg=";
  };

  propagatedBuildInputs = [ django six ];

  # pypi version doesn't include runtest.py, needed to run tests
  doCheck = false;

  meta = with lib; {
    description = "Class based template tags for Django";
    homepage = "https://github.com/divio/django-classy-tags";
    license = licenses.bsd3;
  };

}
