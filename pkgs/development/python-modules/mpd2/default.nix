{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, python
, mock
}:

buildPythonPackage rec {
  pname = "python-mpd2";
  version = "3.0.3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ikvn2qv6cnbjscpbk6hhsqg34h832mxgg6hp1mf4d8d6nwdx4sn";
  };

  buildInputs = [ mock ];

  checkPhase = ''
    ${python.interpreter} -m unittest mpd.tests
  '';

  meta = with lib; {
    description = "A Python client module for the Music Player Daemon";
    homepage = "https://github.com/Mic92/python-mpd2";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ rvl mic92 hexa ];
  };

}
