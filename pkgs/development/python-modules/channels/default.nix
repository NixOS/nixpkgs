{ lib, buildPythonPackage, fetchPypi,
  asgiref, django, daphne
}:
buildPythonPackage rec {
  pname = "channels";
  version = "3.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xcbpfisgawqa34ccgz56wzid0ycp3c8wjcppmz8sgd2hx4skngx";
  };

  # Files are missing in the distribution
  doCheck = false;

  propagatedBuildInputs = [ asgiref django daphne ];

  meta = with lib; {
    description = "Brings event-driven capabilities to Django with a channel system";
    license = licenses.bsd3;
    homepage = "https://github.com/django/channels";
  };
}
