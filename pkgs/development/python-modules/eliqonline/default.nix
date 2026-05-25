{
  lib,
  aiohttp,
  buildPythonPackage,
  docopt,
  fetchPypi,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "eliqonline";
  version = "1.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "hOUN4cA4pKVioIrfJM02GOnZdDRc7xbNtvHfoD3//bM=";
  };

  propagatedBuildInputs = [
    aiohttp
    docopt
    pyyaml
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "eliqonline" ];

  meta = {
    description = "Python client to the Eliq Online API";
    mainProgram = "eliqonline";
    homepage = "https://github.com/molobrakos/eliqonline";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
