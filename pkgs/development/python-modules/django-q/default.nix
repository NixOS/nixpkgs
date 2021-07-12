{ lib, buildPythonPackage, fetchPypi, django-picklefield, arrow
, blessed, django, future }:

buildPythonPackage rec {
  pname = "django-q";
  version = "1.3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "db30266fadd6ab9336a8824291910ff1d1c28f7bc9d6e52cdaf33cc275ae6146";
  };

  propagatedBuildInputs = [
    django-picklefield arrow blessed django future
  ];

  doCheck = false;

  meta = with lib; {
    description = "A multiprocessing distributed task queue for Django";
    homepage = "https://django-q.readthedocs.org";
    license = licenses.mit;
  };
}
