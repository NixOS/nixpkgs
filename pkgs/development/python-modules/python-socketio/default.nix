{ lib
, buildPythonPackage
, fetchPypi
, six
, python-engineio
, mock
}:

buildPythonPackage rec {
  pname = "python-socketio";
  version = "5.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gl9ja1lcppj83bj9452cx6x7das37k4lbq6j82afxczppax0gzm";
  };

  propagatedBuildInputs = [
    six
    python-engineio
  ];

  checkInputs = [ mock ];
  # tests only on github, but latest github release not tagged
  doCheck = false;

  meta = with lib; {
    description = "Socket.IO server";
    homepage = "https://github.com/miguelgrinberg/python-socketio/";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
