{
  lib,
  buildPythonPackage,
  colorlog,
  fetchPypi,
  pyserial,
}:

buildPythonPackage rec {
  pname = "pypca";
  version = "0.0.13";
  format = "setuptools";

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

  meta = {
    description = "Python library for interacting with the PCA 301 smart plugs";
    mainProgram = "pypca";
    homepage = "https://github.com/majuss/pypca";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
