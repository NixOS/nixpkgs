{ lib, buildPythonPackage, fetchPypi, pythonOlder, blessings, mock, nose, pyte, cwcwidth, typing ? null}:

buildPythonPackage rec {
  pname = "curtsies";
  version = "0.3.6";
  src = fetchPypi {
    inherit pname version;
    sha256 = "ffe52cb5a0d87e914574418816b34965085db8f6cffd8951ec227bd7deec738f";
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
