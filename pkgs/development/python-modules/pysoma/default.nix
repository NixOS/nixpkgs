{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pysoma";
  version = "0.0.13";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1bS9zafuqxwcuqpM/AA3ZjNbFpxBNXtoHYFsQOWmLXQ=";
  };

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [ "api" ];

  meta = with lib; {
    description = "Python wrapper for the HTTP API provided by SOMA Connect";
    homepage = "https://pypi.org/project/pysoma";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
