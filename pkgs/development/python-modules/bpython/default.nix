{ stdenv, buildPythonPackage, fetchPypi, pygments, greenlet, curtsies, urwid, requests, mock }:

buildPythonPackage rec {
  pname = "bpython";
  version = "0.17.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8907c510bca3c4d9bc0a157279bdc5e3b739cc68c0f247167279b6fe4becb02f";
  };

  propagatedBuildInputs = [ curtsies greenlet pygments requests urwid ];

  checkInputs = [ mock ];

  # tests fail: https://github.com/bpython/bpython/issues/712
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A fancy curses interface to the Python interactive interpreter";
    homepage = https://bpython-interpreter.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
