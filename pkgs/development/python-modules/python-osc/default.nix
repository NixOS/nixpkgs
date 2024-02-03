{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-osc";
  version = "1.8.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pc4bpWyNgt9Ryz8pRrXdM6cFInkazEuFZOYtKyCtnKo=";
  };

  pythonImportsCheck = [ "pythonosc" ];

  meta = with lib; {
    description = "Open Sound Control server and client in pure python";
    homepage = "https://github.com/attwad/python-osc";
    license = licenses.unlicense;
    maintainers = with maintainers; [ anirrudh ];
  };
}
