{ lib
, buildPythonPackage
, fetchPypi
, six
, python-engineio
, mock
}:

buildPythonPackage rec {
  pname = "python-socketio";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "48cba5b827ac665dbf923a4f5ec590812aed5299a831fc43576a9af346272534";
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
