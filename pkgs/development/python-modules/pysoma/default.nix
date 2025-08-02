{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysoma";
  version = "0.0.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1bS9zafuqxwcuqpM/AA3ZjNbFpxBNXtoHYFsQOWmLXQ=";
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
