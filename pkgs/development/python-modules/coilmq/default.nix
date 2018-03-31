{ stdenv, buildPythonPackage, fetchPypi
, stompclient, pythondaemon, redis, pid, pytest, six, click, coverage
, sqlalchemy }:

buildPythonPackage rec {
  pname = "CoilMQ";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wwa6fsqw1mxsryvgp0yrdjil8axyj0kslzi7lr45cnhgp5ab375";
  };

  propagatedBuildInputs = [ stompclient pythondaemon redis pid ];
  buildInputs = [ pytest six click coverage sqlalchemy ];

  # The teste data is not included in the distribution
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Simple, lightweight, and easily extensible STOMP message broker";
    homepage = http://code.google.com/p/coilmq/;
    license = licenses.asl20;
  };
}
