{ stdenv, buildPythonPackage, fetchPypi
, nose, amqplib, anyjson }:

buildPythonPackage rec {
  pname = "carrot";
  version = "0.10.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s14rs2fgp1s2qa0avn8gj33lwc3k1hd4y9a2h6mhg487i7kfinb";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ amqplib anyjson ];

  doCheck = false; # depends on the network

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/carrot;
    description = "AMQP Messaging Framework for Python";
  };
}
