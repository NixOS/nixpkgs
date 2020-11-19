{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "sacn";
  version = "1.4.6";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "015wa9nhqgd0kb60bw19g86ga25s9mpvsbqkahi3kw6df6j0wzss";
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
