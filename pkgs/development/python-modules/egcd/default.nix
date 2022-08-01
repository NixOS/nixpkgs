{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "egcd";
  version = "0.4.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "lapets";
    repo = pname;
    rev = version;
    sha256 = "I6bjW4TJIXsLvw12DB8oPpM+jSg02l/Lw7FAFu5/wWE=";
  };

  # Project doesn't contain tests
  doCheck = false;
  pythonImportsCheck = [ "egcd" ];

  meta = with lib; {
    description = "Pure-Python implementation of the extended Euclidean algorithm";
    homepage = "https://github.com/lapets/egcd";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
  };
}
