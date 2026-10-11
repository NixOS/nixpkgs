{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "apify-fingerprint-datapoints";
  version = "0.15.0";
  pyproject = true;

  src = fetchPypi {
    pname = "apify_fingerprint_datapoints";
    inherit (finalAttrs) version;
    hash = "sha256-V3b+c/6qORAmXK5VWZVSsJjzpxbYhyyaDCKV/yu2gNw=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "apify_fingerprint_datapoints" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Browser fingerprint datapoints collected by Apify";
    homepage = "https://pypi.org/project/apify-fingerprint-datapoints/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
