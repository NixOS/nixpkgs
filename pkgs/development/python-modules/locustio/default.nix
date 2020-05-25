{ buildPythonPackage, fetchFromGitHub, isPy38
, flask
, gevent
, mock
, msgpack
, pyzmq
, requests
, unittest2
}:

buildPythonPackage rec {
  pname = "locustio";
  version = "0.14.4";
  # tests hang on python38
  disabled = isPy38;

  src = fetchFromGitHub {
    owner = "locustio";
    repo = "locust";
    rev = version;
    sha256 = "1645d63ig4ymw716b6h53bhmjqqc13p9r95k1xfx66ck6vdqnisd";
  };

  propagatedBuildInputs = [ msgpack requests flask gevent pyzmq ];
  checkInputs = [ mock unittest2 ];
  # remove file which attempts to do GET request
  preCheck = ''
    rm locust/test/test_stats.py
  '';

  meta = {
    homepage = "https://locust.io/";
    description = "A load testing tool";
  };
}
