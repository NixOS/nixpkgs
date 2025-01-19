{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "parts";
  version = "2.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zauHOv8pM47CVIQIo8aMMPZJgwIowgbVLvfFWzIqHoc=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "parts" ];

  meta = {
    description = "Library for common list functions related to partitioning lists";
    homepage = "https://github.com/lapets/parts";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
