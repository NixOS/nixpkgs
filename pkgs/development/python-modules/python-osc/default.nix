{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-osc";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-69a3z4rjhzgPSOnW1zabrRwXahr2YI79eIi1C08OdK0=";
  };

  pythonImportsCheck = [ "pythonosc" ];

  meta = with lib; {
    description = "Open Sound Control server and client in pure python";
    homepage = "https://github.com/attwad/python-osc";
    license = licenses.unlicense;
    maintainers = with maintainers; [ anirrudh ];
  };
}
