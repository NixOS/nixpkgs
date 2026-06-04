{
  buildPythonPackage,
  lib,
  fetchPypi,
  portalocker,
  setuptools,
}:

buildPythonPackage rec {
  version = "0.11.10";
  pyproject = true;
  pname = "applicationinsights";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b761f3ef0680acf4731906dfc1807faa6f2a57168ae74592db0084a6099f7b3";
  };

  build-system = [ setuptools ];

  dependencies = [ portalocker ];

  meta = {
    description = "This project extends the Application Insights API surface to support Python";
    homepage = "https://github.com/Microsoft/ApplicationInsights-Python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
