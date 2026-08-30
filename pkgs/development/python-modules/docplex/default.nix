{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  docloud,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "docplex";
  version = "2.32.264";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Tisps1WecCvP4SxnR0KMdSsMOaUIqBrd8F7aqza3a9g=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=78.1.1" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [
    docloud
    requests
  ];

  # PypI release does not include tests
  doCheck = false;

  pythonImportsCheck = [ "docplex" ];

  meta = {
    description = "IBM Decision Optimization CPLEX Modeling for Python";
    homepage = "https://onboarding-oaas.docloud.ibmcloud.com/software/analytics/docloud/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
