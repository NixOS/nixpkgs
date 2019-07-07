{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, gevent
}:

buildPythonPackage rec {
  pname = "gevent-websocket";
  version = "0.10.1";
  # SyntaxError in tests.
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c2zv2rahp1gil3cj66hfsqgy0n35hz9fny3ywhr2319d0lz7bky";
  };

  propagatedBuildInputs = [ gevent ];

  meta = with stdenv.lib; {
    homepage = https://www.gitlab.com/noppo/gevent-websocket;
    description = "Websocket handler for the gevent pywsgi server, a Python network library";
    license = licenses.asl20;
  };

}
