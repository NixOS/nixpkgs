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
    sha256 = "0b6r3ng78qsn7c9zksx4rgdkmp5296d40kbmjn8q614cz0ymyc5k";
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
