{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "neo4j";
  version = "5.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "neo4j";
    repo = "neo4j-python-driver";
    rev = "refs/tags/${version}";
    hash = "sha256-v/IJdgn3C1JgT0KJ9O7wn+5nexDbakzM/u8bAeEPjz0=";
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
