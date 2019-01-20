{ stdenv
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-classy-tags";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f2dc9rq8v9sc4kv4x9hmbzp5c4amdxjkz5nzas5abg2s1hr2bvr";
  };

  propagatedBuildInputs = [ django ];

  # pypi version doesn't include runtest.py, needed to run tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Class based template tags for Django";
    homepage = https://github.com/ojii/django-classy-tags;
    license = licenses.bsd3;
  };

}
