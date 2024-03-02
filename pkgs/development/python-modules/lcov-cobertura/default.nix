{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "lcov-cobertura";
  version = "2.0.2";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "lcov_cobertura";
    inherit version;
    hash = "sha256-xs40e/PuZ/jV0CDNZiYmo1lM8r5yfMY0qg0R+j9/E3Q=";
  };

  doCheck = true;
  pythonImportsCheck = [
    "lcov_cobertura"
  ];

  meta = {
    description = "Converts code coverage from lcov format to Cobertura's XML format";
    homepage = "https://eriwen.github.io/lcov-to-cobertura-xml/";
    license = lib.licenses.asl20;
  };
}
