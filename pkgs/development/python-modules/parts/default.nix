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
  version = "2.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wQgiwr7iOBvy24/w1C311PivWLtXLD/Djs34zo1Zid4=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "parts" ];

  meta = with lib; {
    description = "Library for common list functions related to partitioning lists";
    homepage = "https://github.com/lapets/parts";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
