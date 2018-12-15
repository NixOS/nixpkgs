{ stdenv
, buildPythonPackage
, fetchPypi
, mock
}:

buildPythonPackage rec {
  pname = "mpd2";
  version = "0.5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gfrxf71xll1w6zb69znqg5c9j0g7036fsalkvqprh2id640cl3a";
  };

  buildInputs = [ mock ];
  patchPhase = ''
    sed -i -e '/tests_require/d' \
        -e 's/cmdclass.*/test_suite="mpd_test",/' setup.py
  '';

  meta = with stdenv.lib; {
    description = "A Python client module for the Music Player Daemon";
    homepage = "https://github.com/Mic92/python-mpd2";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ rvl mic92 ];
  };

}
