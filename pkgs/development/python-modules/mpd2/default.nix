{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, python
, mock
}:

buildPythonPackage rec {
  pname = "python-mpd2";
  version = "3.0.4";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r8saq1460yfa0sxfrvxqs2r453wz2xchlc9gzbpqznr49786rvs";
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
