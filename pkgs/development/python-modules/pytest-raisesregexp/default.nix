{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  py,
  pytest,
}:

buildPythonPackage rec {
  pname = "pytest-raisesregexp";
  version = "2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tUNySU/B8ROIsbk0ius2tpYJaZ649G4OAQr8cz14I2o=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    py
    pytest
  ];

  meta = with lib; {
    description = "Simple pytest plugin to look for regex in Exceptions";
    homepage = "https://github.com/Walkman/pytest_raisesregexp";
    license = with licenses; [ mit ];
  };
}
