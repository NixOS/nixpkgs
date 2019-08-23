{ buildPythonPackage
, fetchFromGitHub
, mock
, unittest2
, msgpack
, requests
, flask
, gevent
, pyzmq
}:

buildPythonPackage rec {
  pname = "locustio";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "locustio";
    repo = "locust";
    rev = "${version}";
    sha256 = "1645d63ig4ymw716b6h53bhmjqqc13p9r95k1xfx66ck6vdqnisd";
  };

  propagatedBuildInputs = [ msgpack requests flask gevent pyzmq ];
  buildInputs = [ mock unittest2 ];

  meta = {
    homepage = https://locust.io/;
    description = "A load testing tool";
  };
}
