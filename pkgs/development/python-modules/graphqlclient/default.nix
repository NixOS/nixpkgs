{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
}:

buildPythonPackage rec {
  pname = "graphqlclient";
  version = "0.2.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-szBfPfiMBIORlXVNQJpJotw628uk6/kTO1ZjdJ4d2Sw=";
  };

  propagatedBuildInputs = [ six ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "graphqlclient" ];

  meta = with lib; {
    description = "Simple GraphQL client for Python";
    homepage = "https://github.com/prisma-labs/python-graphql-client";
    license = licenses.mit;
    maintainers = with maintainers; [ lde ];
  };
}
