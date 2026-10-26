{
  lib,
  buildPythonPackage,
  fetchPypi,
  pymongo,
}:

buildPythonPackage (finalAttrs: {
  pname = "mongodict";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-nGbWX9HNPh4D/tnVwRxuNgOhCypgydvXA/WMoV1VZVs=";
  };

  propagatedBuildInputs = [ pymongo ];

  meta = {
    description = "MongoDB-backed Python dict-like interface";
    homepage = "https://github.com/turicas/mongodict/";
    license = lib.licenses.gpl3;
  };
})
