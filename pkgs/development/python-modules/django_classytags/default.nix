{ lib
, buildPythonPackage
, fetchPypi
, django
, six
}:

buildPythonPackage rec {
  pname = "django-classy-tags";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d59d98bdf96a764dcf7a2929a86439d023b283a9152492811c7e44fc47555bc9";
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
