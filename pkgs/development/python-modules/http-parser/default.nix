{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
}:

buildPythonPackage rec {
  pname = "http-parser";
  version = "0.9.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "benoitc";
    repo = pname;
    rev = version;
    sha256 = "05byv1079qi7ypvzm13yf5nc23ink6gr6c5wrhq7fwld4syscy2q";
  };

  checkInputs = [ pytest ];

  checkPhase = "pytest testing/";

  pythonImportsCheck = [ "http_parser" ];

  meta = with lib; {
    description = "HTTP request/response parser for python in C";
    homepage = "https://github.com/benoitc/http-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
