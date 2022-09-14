{ stdenv, lib, buildPythonPackage, fetchPypi, pythonOlder, blessings, mock, nose, pyte, cwcwidth, typing ? null}:

buildPythonPackage rec {
  pname = "curtsies";
  version = "0.4.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yynvzjP+85WinvpWjyf1kTF4Rp+zqrEUCA1spiZBQv4=";
  };

  propagatedBuildInputs = [ blessings cwcwidth ]
    ++ lib.optionals (pythonOlder "3.5") [ typing ];

  checkInputs = [ mock pyte nose ];

  checkPhase = ''
    nosetests tests
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Curses-like terminal wrapper, with colored strings!";
    homepage = "https://github.com/bpython/curtsies";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
