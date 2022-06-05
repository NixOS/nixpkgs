{ lib, buildPythonPackage, fetchPypi, click }:

buildPythonPackage rec {
  pname = "click-log";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OXD4VwrFRJEje82z2KtePu9sBX3yn4w9EVGlGpwjuXU=";
  };

  propagatedBuildInputs = [ click ];

  meta = with lib; {
    homepage = "https://github.com/click-contrib/click-log/";
    description = "Logging integration for Click";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
