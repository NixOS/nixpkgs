{ stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, python
, mock
}:

buildPythonPackage rec {
  pname = "python-mpd2";
  version = "2.0.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17l9k4hcs2zh8y67dpypa6niadz6q2n9fjy5c402mh09hv2kl4md";
  };

  buildInputs = [ mock ];

  checkPhase = ''
    ${python.interpreter} -m unittest mpd.tests
  '';

  meta = with stdenv.lib; {
    description = "A Python client module for the Music Player Daemon";
    homepage = "https://github.com/Mic92/python-mpd2";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ rvl mic92 ];
  };

}
