{ lib, buildPythonPackage, fetchPypi, isPy27, mock, pytest, isort }:

buildPythonPackage rec {
  pname = "pytest-isort";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "46a12331a701e2f21d48548b2828c8b0a7956dbf1cd5347163f537deb24332dd";
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
