{ buildPythonPackage
, fetchPypi
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
  version = "0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y3r2g31z7g120c7v91zdvcakwfxv2acbgs4flarv5yza2knl11c";
  };

  patchPhase = ''
    sed -i s/"pyzmq=="/"pyzmq>="/ setup.py
  '';

  propagatedBuildInputs = [ msgpack requests flask gevent pyzmq ];
  buildInputs = [ mock unittest2 ];

  meta = {
    homepage = http://locust.io/;
    description = "A load testing tool";
  };
}
