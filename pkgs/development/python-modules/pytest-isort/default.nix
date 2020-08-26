{ lib, buildPythonPackage, fetchPypi, isPy27, mock, pytest, isort }:

buildPythonPackage rec {
  pname = "pytest-isort";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01j0sx8yxd7sbmvwky68mvnwrxxs5bjkvi61043jzff1ga92kg9h";
  };

  propagatedBuildInputs = [ isort ];

  checkInputs = [ pytest ]
    ++ lib.optionals isPy27 [ mock ];

  checkPhase = ''
    py.test -vs --cache-clear
  '';

  meta = with lib; {
    description = "Pytest plugin to perform isort checks (import ordering)";
    homepage = "https://github.com/moccu/pytest-isort/";
    license = licenses.bsd3;
  };
}
