{ lib, buildPythonPackage, fetchPypi, pytest, case, pytz, Pyro4, amqp }:

buildPythonPackage rec {
  pname = "kombu";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "529df9e0ecc0bad9fc2b376c3ce4796c41b482cf697b78b71aea6ebe7ca353c8";
  };

  postPatch = ''
    substituteInPlace requirements/test.txt --replace "pytest-sugar" ""
  '';

  checkInputs = [ pytest case pytz Pyro4 ];

  propagatedBuildInputs = [ amqp ];

  meta = with lib; {
    description = "Messaging library for Python";
    homepage    = https://github.com/celery/kombu;
    license     = licenses.bsd3;
  };
}
