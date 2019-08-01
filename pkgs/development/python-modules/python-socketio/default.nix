{ lib
, buildPythonPackage
, fetchPypi
, six
, python-engineio
, mock
}:

buildPythonPackage rec {
  pname = "python-socketio";
  version = "3.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aa702157694d55a743fb6f1cc0bd1af58fbfda8a7d71d747d4b12d6dac29cab3";
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
    homepage = https://github.com/miguelgrinberg/python-socketio/;
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
