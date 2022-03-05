{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-osc";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2f8c187c68d239960fb2eddcb5346a62a9b35e64f2de045b3e5e509f475ca73d";
  };

  pythonImportsCheck = [ "pythonosc" ];

  meta = with lib; {
    description = "Open Sound Control server and client in pure python";
    homepage = "https://github.com/attwad/python-osc";
    license = licenses.unlicense;
    maintainers = with maintainers; [ anirrudh ];
  };
}
