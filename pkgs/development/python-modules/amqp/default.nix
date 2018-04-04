{ stdenv, buildPythonPackage, fetchPypi, pytest, case, vine }:

buildPythonPackage rec {
  pname = "amqp";
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cba1ace9d4ff6049b190d8b7991f9c1006b443a5238021aca96dd6ad2ac9da22";
  };

  buildInputs = [ pytest case ];
  propagatedBuildInputs = [ vine ];

  meta = with stdenv.lib; {
    homepage = https://github.com/celery/py-amqp;
    description = "Python client for the Advanced Message Queuing Procotol (AMQP). This is a fork of amqplib which is maintained by the Celery project";
    license = licenses.lgpl21;
  };
}
