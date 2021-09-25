{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-osc";
  version = "1.7.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c7d68a7719d9425ab2a4ee9a2b9d5a9f5b66593fb46e20e38f91e1452bea2d2";
  };

  pythonImportsCheck = [ "pythonosc" ];

  meta = with lib; {
    description = "Open Sound Control server and client in pure python";
    homepage = "https://github.com/attwad/python-osc";
    license = licenses.unlicense;
    maintainers = with maintainers; [ anirrudh ];
  };
}
