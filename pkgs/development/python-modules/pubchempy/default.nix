{
  buildPythonPackage,
  certifi,
  fetchPypi,
  lib,
  pandas,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pubchempy";
  version = "1.0.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-CPCyqCpcql1h4Uk11lXaVUYC17Vob+Zhq1hMiC//9iM=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    pandas = [ pandas ];
    ssl = [ certifi ];
  };

  # All tests require network access
  doCheck = false;

  pythonImportsCheck = [ "pubchempy" ];

  meta = {
    changelog = "https://github.com/mcs07/PubChemPy/releases/tag/v${finalAttrs.version}";
    description = "Python wrapper for the PubChem PUG REST API";
    homepage = "https://docs.pubchempy.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hythera ];
  };
})
