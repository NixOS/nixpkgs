{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  requests,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "inventree";
  version = "0.19.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;

    hash = "sha256-ZAm8UfsFqNSRpcwDD0hsQEDILO+8If+9UjH8+M00tAQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
    urllib3
  ];

  meta = {
    changelog = "https://github.com/inventree/inventree-python/releases/tag/${finalAttrs.version}";
    description = "API for accessing an inventree instance";
    homepage = "https://github.com/inventree/inventree-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chordtoll ];
  };
})
