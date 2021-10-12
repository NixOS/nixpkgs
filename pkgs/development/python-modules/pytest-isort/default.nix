{ lib, buildPythonPackage, fetchPypi, isPy27, mock, pytest, isort }:

buildPythonPackage rec {
  pname = "pytest-isort";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "821a8c5c9c4f3a3c52cfa9c541fbe89ac9e28728125125af53724c4c3f129117";
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
