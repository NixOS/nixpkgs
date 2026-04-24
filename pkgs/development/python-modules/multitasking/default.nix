{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "multitasking";
  version = "0.0.13";
  format = "setuptools";

  # GitHub source releases aren't tagged
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2Ja134d8nKXu3b8OWZQSRpTWy1NaummPsjNExwJRVaE=";
  };

  doCheck = false; # No tests included
  pythonImportsCheck = [ "multitasking" ];

  meta = {
    description = "Non-blocking Python methods using decorators";
    homepage = "https://github.com/ranaroussi/multitasking";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
