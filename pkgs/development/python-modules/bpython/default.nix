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
  version = "0.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "88aa9b89974f6a7726499a2608fa7ded216d84c69e78114ab2ef996a45709487";
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
