{ stdenv
, buildPythonPackage
, fetchPypi
, python
, mock
}:

buildPythonPackage rec {
  pname = "python-mpd2";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.bz2";
    sha256 = "772fa6861273bb9f363a97987c2c45ca3965eb770570f1f02566efec9c89fc5f";
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
