{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "neo4j";
  version = "5.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "neo4j";
    repo = "neo4j-python-driver";
    rev = "refs/tags/${version}";
    hash = "sha256-d4OkXj6mZjrdRG8UyxWeAh3rLywz2TUk2pZq+Ni1F3s=";
  };

  propagatedBuildInputs = [
    pytz
  ];

  # Missing dependencies
  doCheck = false;

  pythonImportsCheck = [
    "neo4j"
  ];

  meta = with lib; {
    description = "Neo4j Bolt Driver for Python";
    homepage = "https://github.com/neo4j/neo4j-python-driver";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
