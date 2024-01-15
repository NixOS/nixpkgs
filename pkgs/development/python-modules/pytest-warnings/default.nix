{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "pytest-warnings";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5939f76fe04ad18297e53af0c9fb38aca1ec74db807bd40ad72733603adbbc7d";
  };

  buildInputs = [ pytest ];

  meta = {
    description = "Plugin to list Python warnings in pytest report";
    homepage = "https://github.com/fschulze/pytest-warnings";
    license = lib.licenses.mit;
  };
}
