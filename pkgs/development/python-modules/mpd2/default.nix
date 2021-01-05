{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, python
, mock
}:

buildPythonPackage rec {
  pname = "python-mpd2";
  version = "3.0.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fxssbmnv44m03shjyvbqslc69b0160702j2s0flgvdxjggrnbjj";
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
