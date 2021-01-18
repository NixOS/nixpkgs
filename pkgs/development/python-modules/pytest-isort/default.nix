{ lib, buildPythonPackage, fetchPypi, isPy27, mock, pytest, isort }:

buildPythonPackage rec {
  pname = "pytest-isort";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0fcf9674f3a627b36e07466d335e82b0f7c4f9e0f7ec39f2a1750b0189d5371";
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
