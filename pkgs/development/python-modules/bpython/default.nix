{ stdenv, buildPythonPackage, fetchPypi, pygments, greenlet, curtsies, urwid, requests, mock }:

buildPythonPackage rec {
  pname = "bpython";
  version = "0.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "56cc20dbe568c98c81de4990fddf5862c0d8d3ab0ad1cf7057988abc5f7686c2";
  };

  propagatedBuildInputs = [ curtsies greenlet pygments requests urwid ];

  postInstall = ''
    substituteInPlace "$out/share/applications/bpython.desktop" \
      --replace "Exec=/usr/bin/bpython" "Exec=$out/bin/bpython"
  '';

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
