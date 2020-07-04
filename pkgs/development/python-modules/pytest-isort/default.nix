{ lib, buildPythonPackage, fetchPypi, isPy27, mock, pytest, isort }:

buildPythonPackage rec {
  pname = "pytest-isort";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "758156cb4dc1db72adc1b7e253011f5eea117fab32af03cedb4cbfc6058b5f8f";
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
