{ lib
, buildPythonPackage
, fetchPypi
, six
, python-engineio
, mock
}:

buildPythonPackage rec {
  pname = "python-socketio";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e9d87d5f3cd6d39c42dd665e1fe3e12361637e28f5ad9a7aa8f73358b7a3dd5";
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
    homepage = http://github.com/miguelgrinberg/python-socketio/;
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
