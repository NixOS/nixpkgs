{ lib, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, python
, mock
}:

buildPythonPackage rec {
  pname = "python-mpd2";
  version = "3.0.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ibl2xyj4380ai60i2bfhm8qn1sjyjbwwjmgzfcqa12wlnhck7ki";
  };

  buildInputs = [ mock ];

  checkPhase = ''
    ${python.interpreter} -m unittest mpd.tests
  '';

  meta = with lib; {
    description = "A Python client module for the Music Player Daemon";
    homepage = "https://github.com/Mic92/python-mpd2";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ rvl mic92 ];
  };

}
