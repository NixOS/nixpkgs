{ stdenv, buildPythonPackage, fetchurl }:

buildPythonPackage rec {
  pname = "amqplib";
  version = "0.6.1";

  src = fetchurl {
    url = https://github.com/barryp/py-amqplib/archive/0.6.1.tar.gz;
    sha256 = "04nsn68wz9m24rvbssirkyighazbn20j60wjmi0r7jcpcf00sb3s";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/py-amqplib/;
    description = "Python client for the Advanced Message Queuing Procotol (AMQP)";
    license = licenses.lgpl21;
  };
}
