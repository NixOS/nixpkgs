{ stdenv, buildPythonPackage, fetchPypi, pytest, case, vine, pytest-sugar }:

buildPythonPackage rec {
  pname = "amqp";
  version = "2.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "043beb485774ca69718a35602089e524f87168268f0d1ae115f28b88d27f92d7";
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
