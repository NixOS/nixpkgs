{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytz
, tomlkit
}:

buildPythonPackage rec {
  pname = "neo4j";
  version = "5.16.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "neo4j";
    repo = "neo4j-python-driver";
    rev = "refs/tags/${version}";
    hash = "sha256-ly/R2ufd5gEkUyfajpeMQblTiKipC9HFtxkWkh16zLo=";
  };

  propagatedBuildInputs = [
    pytz
    tomlkit
  ];

  # Missing dependencies
  doCheck = false;

  pythonImportsCheck = [
    "neo4j"
  ];

  meta = with lib; {
    description = "Neo4j Bolt Driver for Python";
    homepage = "https://github.com/neo4j/neo4j-python-driver";
    changelog = "https://github.com/neo4j/neo4j-python-driver/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
