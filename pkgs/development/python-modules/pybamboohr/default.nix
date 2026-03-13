{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "pybamboohr";
  version = "0.8.1";
  pyproject = true;

  src = fetchPypi {
    pname = "PyBambooHR";
    inherit version;
    hash = "sha256-rzKzbwBJpi6LpL7dpyI+PKs+i+VI3q3cD/eY+s8W2lQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    xmltodict
  ];

  # Tests require network access to the BambooHR API
  doCheck = false;

  pythonImportsCheck = [ "PyBambooHR" ];

  meta = {
    description = "Python wrapper for the BambooHR API";
    homepage = "https://github.com/smeggingsmegger/PyBambooHR";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
