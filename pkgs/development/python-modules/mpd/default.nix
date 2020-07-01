{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "python-mpd";
  version = "0.3.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "02812eba1d2e0f46e37457f5a6fa23ba203622e4bcab0a19b265e66b08cd21b4";
  };

  meta = with stdenv.lib; {
    description = "An MPD (Music Player Daemon) client library written in pure Python";
    homepage = "http://jatreuman.indefero.net/p/python-mpd/";
    license = licenses.gpl3;
  };

}
