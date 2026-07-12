{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pysoma";
  version = "0.0.14";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DlyOQmhseCIeaYlzTmkQBSlDjJlPZn7FRExil5gQjdY=";
  };

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [ "api" ];

  meta = {
    description = "Python wrapper for the HTTP API provided by SOMA Connect";
    homepage = "https://pypi.org/project/pysoma";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
