{ stdenv, buildPythonPackage, fetchurl }:

buildPythonPackage rec {
  pname = "amqplib";
  version = "1.0.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = https://github.com/barryp/py-amqplib/archive/1.0.2.tar.gz;
    sha256 = "0dir9kvh0kfqfwq27j7v3pk4h69askdbaf37cmmlww6aflzxfqcl";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/py-amqplib/;
    description = "Python client for the Advanced Message Queuing Procotol (AMQP)";
  };
}
