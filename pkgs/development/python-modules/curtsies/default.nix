{ lib, buildPythonPackage, fetchPypi, pythonOlder, blessings, mock, nose, pyte, cwcwidth, typing ? null}:

buildPythonPackage rec {
  pname = "curtsies";
  version = "0.3.5";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1g8dwafx4vx06isjkn28r3cwb0hw1bv67lgygaz34yk66lrzz1x5";
  };

  propagatedBuildInputs = [ blessings cwcwidth ]
    ++ lib.optionals (pythonOlder "3.5") [ typing ];

  checkInputs = [ mock pyte nose ];

  checkPhase = ''
    nosetests tests
  '';

  meta = with lib; {
    description = "Curses-like terminal wrapper, with colored strings!";
    homepage = "https://github.com/bpython/curtsies";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
