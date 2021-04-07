{ lib
, buildPythonPackage
, fetchPypi
, versiontools
, gevent-websocket
, mock
, pytest
, gevent
}:

buildPythonPackage rec {
  pname = "gevent-socketio";
  version = "0.3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zra86hg2l1jcpl9nsnqagy3nl3akws8bvrbpgdxk15x7ywllfak";
  };

  buildInputs = [ versiontools gevent-websocket mock pytest ];
  propagatedBuildInputs = [ gevent ];

  meta = with lib; {
    homepage = "https://github.com/abourget/gevent-socketio";
    description = "SocketIO server based on the Gevent pywsgi server, a Python network library";
    license = licenses.bsd0;
  };

}
