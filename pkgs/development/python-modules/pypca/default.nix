{
  lib,
  buildPythonPackage,
  colorlog,
  fetchPypi,
  pythonOlder,
  pyserial,
}:

buildPythonPackage rec {
  pname = "pypca";
  version = "0.0.13";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tC19C+TYtjwxGxMujZNJYKXDpBNkxxunr0F0IWoWF3g=";
  };

  propagatedBuildInputs = [
    colorlog
    pyserial
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pypca" ];

  meta = with lib; {
    description = "Python library for interacting with the PCA 301 smart plugs";
    mainProgram = "pypca";
    homepage = "https://github.com/majuss/pypca";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
