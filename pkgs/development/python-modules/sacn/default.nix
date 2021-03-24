{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "sacn";
  version = "1.6.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2fea82a1dd83b0a67dc0be68a53b1fef1c44b12f3f018e47ac736bd15b36c068";
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
