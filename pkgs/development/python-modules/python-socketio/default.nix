{ lib
, buildPythonPackage
, fetchPypi
, six
, python-engineio
, mock
}:

buildPythonPackage rec {
  pname = "python-socketio";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10457ahvi16iyshmynr0j9palfsbnpzya8p1nmlhzrcr11fsnkb7";
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
