{
  lib,
  aiohttp,
  cbor2,
  cryptography,
  buildPythonPackage,
  fetchPypi,
  pyjwt,
  setuptools,
  requests,
  sqlalchemy,
}:

buildPythonPackage (finalAttrs: {
  pname = "roadlib";
  version = "1.7.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-al1FnLcKAFWRY43weXtsS8DN5pXCO1qFUw1vwLfZvGM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cbor2
    cryptography
    pyjwt
    requests
    sqlalchemy
  ];

  optional-dependencies = {
    async = [ aiohttp ];
  };

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "roadtools.roadlib" ];

  meta = {
    description = "ROADtools common components library";
    homepage = "https://pypi.org/project/roadlib/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
