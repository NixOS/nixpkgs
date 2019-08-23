{ stdenv
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-classy-tags";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0axzsigvmb17ha5mnr3xf6c851kwinjpkxksxwprwjakh1m59d1q";
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
