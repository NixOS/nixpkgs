{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "localimport";
  version = "1.7.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-p7ACOzJRwH9hICMcxtVt/r+twEoFsDxPKGuarFnFIbo=";
  };

  pythonImportsCheck = [ "localimport" ];

  meta = with lib; {
    homepage = "https://github.com/NiklasRosenstein/py-localimport";
    description = "Isolated import of Python modules";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
