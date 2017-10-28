{ stdenv, buildPythonPackage, fetchPypi, msgpack, requests, flask, gevent
, pyzmq, mock, unittest2 }:

buildPythonPackage rec {
  pname = "locustio";
  version = "0.7.5";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ln7n3mx38syh6302nkg1klncyjh68xndjrfdalnkvqvflidmpg6";
  };
  patches = [
    ./gevent.patch
  ];

  propagatedBuildInputs = [ msgpack requests flask gevent pyzmq ];
  buildInputs = [ mock unittest2 ];
  # Build test fails due to newer flask version than test suite allows.
  # See: https://github.com/locustio/locust/issues/637
  doCheck = false;

  meta = {
    homepage = http://locust.io/;
    description = "A load testing tool";
  };
}
