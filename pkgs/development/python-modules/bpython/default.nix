{ stdenv, buildPythonPackage, fetchPypi, pygments, greenlet, curtsies, urwid, requests, mock }:

buildPythonPackage rec {
  pname = "bpython";
  version = "0.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mbah208jhd7bsfaa17fwpi55f7fvif0ghjwgrjmpmx8w1vqab9l";
  };

  propagatedBuildInputs = [ curtsies greenlet pygments requests urwid ];

  checkInputs = [ mock ];

  # tests fail: https://github.com/bpython/bpython/issues/712
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A fancy curses interface to the Python interactive interpreter";
    homepage = "https://bpython-interpreter.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
