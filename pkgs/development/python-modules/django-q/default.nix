{ stdenv, buildPythonPackage, fetchPypi, django-picklefield, arrow
, blessed, django, future }:

buildPythonPackage rec {
  pname = "django-q";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17mqxiacsp2yszak6j48fm7vx0w44pcg86flc63r9y5yhx490n5r";
  };

  propagatedBuildInputs = [
    django-picklefield arrow blessed django future
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A multiprocessing distributed task queue for Django";
    homepage = https://django-q.readthedocs.org;
    license = licenses.mit;
  };
}
