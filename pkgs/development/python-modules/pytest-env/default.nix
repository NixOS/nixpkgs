{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "pytest-env";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-17L1Jz7G0eIhdXmYvC9Q0kdO19C5MxuSVWAR+txOmr8=";
  };

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "Pytest plugin used to set environment variables";
    homepage = "https://github.com/MobileDynasty/pytest-env";
    license = licenses.mit;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
