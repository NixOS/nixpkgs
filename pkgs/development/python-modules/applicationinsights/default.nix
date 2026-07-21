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

  __structuredAttrs = true;

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
    changelog = "https://pypi.org/project/applicationinsights/${finalAttrs.version}/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
