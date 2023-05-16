{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytz
, tomlkit
}:

buildPythonPackage rec {
  pname = "neo4j";
<<<<<<< HEAD
  version = "5.12.0";
=======
  version = "5.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "neo4j";
    repo = "neo4j-python-driver";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-feKKBbULkWxEgUaMROvmQph2YTAgSOVDRz/OnpzG9Ac=";
=======
    hash = "sha256-11fa6scRcC+bQxEccCgxSJaMjwkUVs4DQj1NSaXlpb8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
