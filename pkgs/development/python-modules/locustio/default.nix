{ buildPythonPackage
, fetchPypi
, mock
, unittest2
, msgpack-python
, requests
, flask
, gevent
, pyzmq
}:

buildPythonPackage rec {
  pname = "locustio";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "64583987ba1c330bb071aee3e29d2eedbfb7c8b342fa064bfb74fafcff660d61";
  };

  patchPhase = ''
    sed -i s/"pyzmq=="/"pyzmq>="/ setup.py
  '';

  propagatedBuildInputs = [ msgpack-python requests flask gevent pyzmq ];
  buildInputs = [ mock unittest2 ];

  meta = {
    homepage = https://locust.io/;
    description = "A load testing tool";
  };
}
