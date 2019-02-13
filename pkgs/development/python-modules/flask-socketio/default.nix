{ lib
, buildPythonPackage
, fetchPypi
, flask
, python-socketio
, coverage
}:

buildPythonPackage rec {
  pname = "Flask-SocketIO";
  version = "3.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hcl0qnhfqc9x4y6fnvsrablim8yfqfg2i097b2v3srlz69vdyr6";
  };

  propagatedBuildInputs = [
    flask
    python-socketio
  ];

  checkInputs = [ coverage ];
  # tests only on github, but lates release there is not tagged
  doCheck = false;

  meta = with lib; {
    description = "Socket.IO integration for Flask applications";
    homepage = http://github.com/miguelgrinberg/Flask-SocketIO/;
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
