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
    homepage = "https://community.ibm.com/community/user/groups/community-home?communitykey=ab7de0fd-6f43-47a9-8261-33578a231bb7";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
