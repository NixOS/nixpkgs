{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "progressbar";
  version = "2.3";

  # https://github.com/niltonvolpato/python-progressbar/issues/54
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2d38a729785149e65323381d2e6fca0a5e9615a6d8bcf10bfa8adedfc481254";
  };

  # invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/progressbar;
    description = "Text progressbar library for python";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ domenkozar ];
  };
}
