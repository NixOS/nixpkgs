{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  distutils,
}:

buildPythonPackage rec {
  pname = "lcov-cobertura";
  version = "2.0.2";
  pyproject = true;
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "lcov_cobertura";
    inherit version;
    hash = "sha256-xs40e/PuZ/jV0CDNZiYmo1lM8r5yfMY0qg0R+j9/E3Q=";
  };

  build-system = [ setuptools ];
  dependencies = [ distutils ];

  pythonImportsCheck = [ "lcov_cobertura" ];

  meta = {
    description = "Converts code coverage from lcov format to Cobertura's XML format";
    mainProgram = "lcov_cobertura";
    homepage = "https://eriwen.github.io/lcov-to-cobertura-xml/";
    license = lib.licenses.asl20;
  };
}
