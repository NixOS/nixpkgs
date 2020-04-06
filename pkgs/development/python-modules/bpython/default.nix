{ stdenv, buildPythonPackage, fetchPypi, pygments, greenlet, curtsies, urwid, requests, mock }:

buildPythonPackage rec {
  pname = "bpython";
  version = "0.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1764ikgj24jjq46s50apwkydqvy5a13adb2nbszk8kbci6df0v27";
  };

  propagatedBuildInputs = [ curtsies greenlet pygments requests urwid ];

  postInstall = ''
    substituteInPlace "$out/share/applications/org.bpython-interpreter.bpython.desktop" \
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
