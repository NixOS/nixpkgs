{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "sacn";
  version = "1.6.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1abkalzpy8bj2hpx563bxii5h0gv9v89f0yp9clc1l76amyf6dj2";
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
