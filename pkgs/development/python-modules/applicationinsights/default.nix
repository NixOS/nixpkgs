{
  buildPythonPackage,
  lib,
  fetchPypi,
  portalocker,
}:

buildPythonPackage rec {
  version = "0.11.10";
  format = "setuptools";
  pname = "applicationinsights";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b761f3ef0680acf4731906dfc1807faa6f2a57168ae74592db0084a6099f7b3";
  };

  propagatedBuildInputs = [ portalocker ];

  meta = with lib; {
    description = "This project extends the Application Insights API surface to support Python";
    homepage = "https://github.com/Microsoft/ApplicationInsights-Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
