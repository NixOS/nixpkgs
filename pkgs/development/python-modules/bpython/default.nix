{ lib
, buildPythonPackage
, fetchPypi
, curtsies
, greenlet
, jedi
, pygments
, pyxdg
, requests
, substituteAll
, urwid
, watchdog
, which
}:

buildPythonPackage rec {
  pname = "bpython";
  version = "0.22.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fb1e0a52332579fc4e3dcf75e21796af67aae2be460179ecfcce9530a49a200";
  };

  propagatedBuildInputs = [
    curtsies
    greenlet
    pygments
    pyxdg
    requests
    urwid
  ];

  postInstall = ''
    substituteInPlace "$out/share/applications/org.bpython-interpreter.bpython.desktop" \
      --replace "Exec=/usr/bin/bpython" "Exec=$out/bin/bpython"
  '';

  checkInputs = [ jedi watchdog ];
  pythonImportsCheck = [ "bpython" ];

  meta = with lib; {
    description = "A fancy curses interface to the Python interactive interpreter";
    homepage = "https://bpython-interpreter.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
