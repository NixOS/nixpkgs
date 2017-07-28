{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "amqplib";
  version = "0.6.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f2618b74d95cd360a6d46a309a3fb1c37d881a237e269ac195a69a34e0e2f62";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/py-amqplib/;
    description = "Python client for the Advanced Message Queuing Procotol (AMQP)";
  };
}
