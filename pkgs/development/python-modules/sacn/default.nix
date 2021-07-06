{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "sacn";
  version = "1.7.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "136gw09av7r2y02q7aam4chhivpbwkdskwwavrl5v0zn34y0axwp";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "sacn" ];

  meta = with lib; {
    description = "A simple ANSI E1.31 (aka sACN) module for python";
    homepage = "https://github.com/Hundemeier/sacn";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
