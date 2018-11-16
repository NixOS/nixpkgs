{ stdenv, buildPythonPackage, fetchPypi, pytest, case, vine, pytest-sugar }:

buildPythonPackage rec {
  pname = "amqp";
  version = "2.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "073dd02fdd73041bffc913b767866015147b61f2a9bc104daef172fc1a0066eb";
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
