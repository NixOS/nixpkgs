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
  version = "2.30.251";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZQMhn1tRJ1p+TnfKQzKQOw+Akl0gUDCkjT9qp8oNvyo=";
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

  meta = with lib; {
    description = "IBM Decision Optimization CPLEX Modeling for Python";
    homepage = "https://onboarding-oaas.docloud.ibmcloud.com/software/analytics/docloud/";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
