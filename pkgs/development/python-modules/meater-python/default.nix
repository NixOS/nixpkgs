{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "meater-python";
  version = "0.0.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-86XJmKOc2MCyU9v0UAZsPCUL/kAXywOlQOIHaykNF1o=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "meater" ];

<<<<<<< HEAD
  meta = {
    description = "Library for the Apption Labs Meater cooking probe";
    homepage = "https://github.com/Sotolotl/meater-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Library for the Apption Labs Meater cooking probe";
    homepage = "https://github.com/Sotolotl/meater-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
