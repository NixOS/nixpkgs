{ lib, buildPythonPackage, fetchPypi, pytest, isort }:

buildPythonPackage rec {
  pname = "pytest-isort";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4bfee60dad1870b51700d55a85f5ceda766bd9d3d2878c1bbabee80e61b1be1a";
  };

  propagatedBuildInputs = [ isort ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test -vs --cache-clear
  '';

  meta = with lib; {
    description = "Pytest plugin to perform isort checks (import ordering)";
    homepage = https://github.com/moccu/pytest-isort/;
    license = licenses.bsd3;
  };
}
