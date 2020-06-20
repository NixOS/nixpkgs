{ stdenv
, buildPythonPackage
, fetchPypi
, django
, six
}:

buildPythonPackage rec {
  pname = "django-classy-tags";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cayqddvxd5prhybqi77lif2z4j7mmfmxgc61pq9i82q5gy2asmd";
  };

  propagatedBuildInputs = [ django six ];

  # pypi version doesn't include runtest.py, needed to run tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Class based template tags for Django";
    homepage = "https://github.com/divio/django-classy-tags";
    license = licenses.bsd3;
  };

}
