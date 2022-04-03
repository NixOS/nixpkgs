{ lib, buildPythonPackage, fetchPypi, bottle, waitress, doreah }:

buildPythonPackage rec {
  pname = "nimrodel";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-eYCdrnILi1s+YWREQa2ihRLn2+P1+cSbQccfUujRJD8=";
  };

  propagatedBuildInputs = [ bottle waitress doreah];

  pythonImportsCheck = [ "nimrodel" ];

  meta = with lib; {
    description = "Bottle-wrapper to make python objects accessible via HTTP API";
    homepage = "https://github.com/krateng/nimrodel/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sohalt ];
  };
}
