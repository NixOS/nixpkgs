{ stdenv, buildPythonPackage, fetchPypi, django-picklefield, arrow
, blessed, django, future }:

buildPythonPackage rec {
  pname = "django-q";
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de7077660ede36bfdd89ab9405d6393b598bb3e0bfed61f59a0a9074cc4942bb";
  };

  propagatedBuildInputs = [
    django-picklefield arrow blessed django future
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A multiprocessing distributed task queue for Django";
    homepage = "https://django-q.readthedocs.org";
    license = licenses.mit;
  };
}
