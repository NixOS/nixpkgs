{
  lib,
  buildPythonPackage,
  fetchPypi,
  pymongo,
}:

buildPythonPackage rec {
  pname = "mongodict";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nGbWX9HNPh4D/tnVwRxuNgOhCypgydvXA/WMoV1VZVs=";
  };

  propagatedBuildInputs = [ pymongo ];

  meta = with lib; {
    description = "MongoDB-backed Python dict-like interface";
    homepage = "https://github.com/turicas/mongodict/";
    license = licenses.gpl3;
  };
}
