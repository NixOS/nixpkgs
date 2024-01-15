{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pycosat";
  version = "0.6.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "4c99874946a7e939bb941bbb019dd2c20e6068e3107c91366e7779c69d70e0ed";
  };

  meta = {
    description = "Bindings to picosat SAT solver";
    homepage = "https://github.com/ContinuumIO/pycosat";
    license = lib.licenses.mit;
  };
}
