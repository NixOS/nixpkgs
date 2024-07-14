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
    hash = "sha256-C3YfPvBoCs9HMZBt/BgH+qbypXFornRZLbAISmCZ97M=";
  };

  propagatedBuildInputs = [ portalocker ];

  meta = with lib; {
    description = "This project extends the Application Insights API surface to support Python";
    homepage = "https://github.com/Microsoft/ApplicationInsights-Python";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
