{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, gevent
}:

buildPythonPackage rec {
  pname = "gevent-websocket";
  version = "0.9.3";
  # SyntaxError in tests.
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "07rqwfpbv13mk6gg8mf0bmvcf6siyffjpgai1xd8ky7r801j4xb4";
  };

  propagatedBuildInputs = [ gevent ];

  meta = with stdenv.lib; {
    homepage = https://www.gitlab.com/noppo/gevent-websocket;
    description = "Websocket handler for the gevent pywsgi server, a Python network library";
    license = licenses.asl20;
  };

}
