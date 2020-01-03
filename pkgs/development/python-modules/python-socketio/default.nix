{ lib
, buildPythonPackage
, fetchPypi
, six
, python-engineio
, mock
}:

buildPythonPackage rec {
  pname = "python-socketio";
  version = "4.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "506b2cf7a520b40ea0b3f25e1272eff8de134dce6f471c1f6bc0de8c90fe8c57";
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
