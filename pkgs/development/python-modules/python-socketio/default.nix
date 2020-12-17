{ lib
, buildPythonPackage
, fetchPypi
, six
, python-engineio
, mock
}:

buildPythonPackage rec {
  pname = "python-socketio";
  version = "4.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cd1f5aa492c1eb2be77838e837a495f117e17f686029ebc03d62c09e33f4fa10";
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
