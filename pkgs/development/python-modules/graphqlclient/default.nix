{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "graphqlclient";
  version = "0.2.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "graphqlclient";
    inherit (finalAttrs) version;
    hash = "sha256-szBfPfiMBIORlXVNQJpJotw628uk6/kTO1ZjdJ4d2Sw=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "graphqlclient" ];

  meta = {
    description = "Simple GraphQL client for Python";
    homepage = "https://github.com/prisma-labs/python-graphql-client";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lde ];
  };
})
