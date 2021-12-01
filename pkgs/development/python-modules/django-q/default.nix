{ lib, buildPythonPackage, fetchPypi, django-picklefield, arrow
, blessed, django, future }:

buildPythonPackage rec {
  pname = "django-q";
  version = "1.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c6b4d530aa3aabf9c6aa57376da1ca2abf89a1562b77038b7a04e52a4a0a91b";
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
