{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pycosat";
  version = "0.6.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-TJmHSUan6Tm7lBu7AZ3Swg5gaOMQfJE2bnd5xp1w4O0=";
  };

  meta = {
    description = "Bindings to picosat SAT solver";
    homepage = "https://github.com/ContinuumIO/pycosat";
    license = lib.licenses.mit;
  };
}
