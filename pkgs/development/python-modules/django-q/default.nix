{ stdenv, buildPythonPackage, fetchPypi, django-picklefield, arrow
, blessed, django, future }:

buildPythonPackage rec {
  pname = "django-q";
  version = "1.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6838e6dda377ab6bd31f5721a66aa6d19ad9a88ca9c03cbb464b2321d3c4c979";
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
