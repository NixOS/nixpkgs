{ stdenv, lib, buildPythonPackage, fetchPypi, pythonOlder, blessings, mock, nose, pyte, cwcwidth, typing ? null}:

buildPythonPackage rec {
  pname = "curtsies";
  version = "0.3.10";
  src = fetchPypi {
    inherit pname version;
    sha256 = "11efbb153d9cb22223dd9a44041ea0c313b8411e246e7f684aa843f6aa9c1600";
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
