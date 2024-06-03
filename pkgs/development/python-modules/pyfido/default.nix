{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyfido";
  version = "2.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hh2g46GVCkiMHElEP6McY8FdzGNzZV7pgA5DQhodP20=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pyfido" ];

  meta = with lib; {
    description = "Python client to get fido account data";
    mainProgram = "pyfido";
    homepage = "https://github.com/titilambert/pyfido";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
