{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "meater-python";
  version = "0.0.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-86XJmKOc2MCyU9v0UAZsPCUL/kAXywOlQOIHaykNF1o=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "meater" ];

  meta = with lib; {
    description = "Library for the Apption Labs Meater cooking probe";
    homepage = "https://github.com/Sotolotl/meater-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
