{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  docloud,
  requests,
}:

buildPythonPackage rec {
  pname = "docplex";
  version = "2.31.254";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LGMpeN3r9/xIzLhGwtWrTrXs0CUMDGEmspu6vVNpwEY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=68.2.2" "setuptools>=68.2.2"
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
}
