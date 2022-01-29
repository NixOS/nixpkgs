{ lib
, buildPythonPackage
, fetchPypi
, django
, six
}:

buildPythonPackage rec {
  pname = "django-classy-tags";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ef8b82b4f7d77d4fd152b25c45128d926e7a5840d862f2ecd3e5faf6acbe343";
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
