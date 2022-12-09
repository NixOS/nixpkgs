{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "sacn";
  version = "1.9.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LimA0I8y1tdjFk244iWvKJj0Rx3OEaYOSIJtirRHh4o=";
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
