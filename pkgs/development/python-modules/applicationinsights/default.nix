{
  buildPythonPackage,
  lib,
  fetchPypi,
  portalocker,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  version = "0.11.10";
  pyproject = true;
  pname = "applicationinsights";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-C3YfPvBoCs9HMZBt/BgH+qbypXFornRZLbAISmCZ97M=";
  };

  build-system = [ setuptools ];

  dependencies = [ portalocker ];

  pythonImportsCheck = [ "applicationinsights" ];

  meta = {
    description = "This project extends the Application Insights API surface to support Python";
    homepage = "https://github.com/Microsoft/ApplicationInsights-Python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
