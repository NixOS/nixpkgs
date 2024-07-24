{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "nclib";
  version = "1.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sKbISlL5hOBu1j6zWSib2HjJCvEoMrqdwzgG2keMqDE=";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "nclib" ];

  meta = with lib; {
    description = "Python module that provides netcat features";
    mainProgram = "serve-stdio";
    homepage = "https://nclib.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
