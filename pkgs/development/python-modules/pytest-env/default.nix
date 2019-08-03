{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "pytest-env";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hl0ln0cicdid4qjk7mv90lw9xkb0v71dlj7q7rn89vzxxm9b53y";
  };

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "Pytest plugin used to set environment variables";
    homepage = https://github.com/MobileDynasty/pytest-env;
    license = licenses.mit;
    maintainers = with maintainers; [ earvstedt ];
  };
}
