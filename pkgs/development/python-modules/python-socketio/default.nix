{ lib
, buildPythonPackage
, fetchPypi
, six
, python-engineio
, mock
}:

buildPythonPackage rec {
  pname = "python-socketio";
  version = "4.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "358d8fbbc029c4538ea25bcaa283e47f375be0017fcba829de8a3a731c9df25a";
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
