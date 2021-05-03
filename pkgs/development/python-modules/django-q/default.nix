{ lib, buildPythonPackage, fetchPypi, django-picklefield, arrow
, blessed, django, future }:

buildPythonPackage rec {
  pname = "django-q";
  version = "1.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8871c602e2c7e892fbedc271d5b91c4a96803b689c3ee2f15464931f99f4e32b";
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
