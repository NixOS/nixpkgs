{ lib, buildPythonPackage, fetchPypi, pythonOlder, blessings, mock, nose, pyte, cwcwidth, typing ? null}:

buildPythonPackage rec {
  pname = "curtsies";
  version = "0.3.9";
  src = fetchPypi {
    inherit pname version;
    sha256 = "933b503767ce38fe32a1f77639d9a4fa3d5229d41abb31a91a6fcbdf01511a55";
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
