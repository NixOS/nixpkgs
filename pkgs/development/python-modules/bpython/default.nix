{ stdenv, buildPythonPackage, fetchurl, pygments, greenlet, curtsies, urwid, requests, mock }:

buildPythonPackage rec {
  pname = "bpython";
  version = "0.17";
  name  = "${pname}-${version}";

  # 0.17 is still missing on PyPI, https://github.com/bpython/bpython/issues/706
  src = fetchurl {
    url = "https://bpython-interpreter.org/releases/${pname}-${version}.tar.gz";
    sha256 = "13fyyx06645ikvmj9zmkixr12kzk1c3a3f9s9i2rvaczjycn82lz";
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
