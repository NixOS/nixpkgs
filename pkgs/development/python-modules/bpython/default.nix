{ lib
, buildPythonPackage
, fetchPypi
, curtsies
, greenlet
, mock
, pygments
, requests
, substituteAll
, urwid
, which }:

buildPythonPackage rec {
  pname = "bpython";
  version = "0.20.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e7738806013b469be57b0117082b9c4557ed7c92c70ceb79f96d674d89c7503";
  };

  patches = [ (substituteAll {
    src = ./clipboard-make-which-substitutable.patch;
    which = "${which}/bin/which";
  })];

  propagatedBuildInputs = [ curtsies greenlet pygments requests urwid ];

  postInstall = ''
    substituteInPlace "$out/share/applications/org.bpython-interpreter.bpython.desktop" \
      --replace "Exec=/usr/bin/bpython" "Exec=$out/bin/bpython"
  '';

  checkInputs = [ mock ];

  # tests fail: https://github.com/bpython/bpython/issues/712
  doCheck = false;

  meta = with lib; {
    description = "A fancy curses interface to the Python interactive interpreter";
    homepage = "https://bpython-interpreter.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
