{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nclib";
  version = "1.0.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-40Bdkhmd3LiZAR1v36puV9l4tgtDb6T8k9j02JTR4Jo=";
  };

  build-system = [ setuptools ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "nclib" ];

  meta = with lib; {
    description = "Python module that provides netcat features";
    homepage = "https://nclib.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "serve-stdio";
  };
}
