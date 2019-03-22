{ stdenv, buildPythonPackage, fetchPypi, pytest, case, vine, pytest-sugar }:

buildPythonPackage rec {
  pname = "amqp";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6816eed27521293ee03aa9ace300a07215b11fee4e845588a9b863a7ba30addb";
  };

  checkInputs = [ pytest case pytest-sugar ];
  propagatedBuildInputs = [ vine ];

  # Disable because pytest-sugar requires an old version of pytest
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/celery/py-amqp;
    description = "Python client for the Advanced Message Queuing Procotol (AMQP). This is a fork of amqplib which is maintained by the Celery project";
    license = licenses.lgpl21;
  };
}
