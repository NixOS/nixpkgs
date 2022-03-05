{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "neo4j-driver";
  version = "4.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "neo4j";
    repo = "neo4j-python-driver";
    rev = version;
    sha256 = "sha256-aGOqD6mmd3dulQ/SdaDPDZhkCwXdYCucHw+CrkJf1M0=";
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
