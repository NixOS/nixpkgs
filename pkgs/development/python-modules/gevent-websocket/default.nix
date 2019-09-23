{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, gevent
, gunicorn
}:

buildPythonPackage rec {
  pname = "gevent-websocket";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c2zv2rahp1gil3cj66hfsqgy0n35hz9fny3ywhr2319d0lz7bky";
  };

  propagatedBuildInputs = [ gevent gunicorn ];

  meta = with stdenv.lib; {
    homepage = https://www.gitlab.com/noppo/gevent-websocket;
    description = "Websocket handler for the gevent pywsgi server, a Python network library";
    license = licenses.asl20;
  };

}
