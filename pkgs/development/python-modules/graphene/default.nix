{ lib
, aniso8601
, buildPythonPackage
, fetchFromGitHub
, graphql-core
, graphql-relay
, promise
, py
, pytest-asyncio
, pytest-benchmark
, pytest-mock
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, pytz
, snapshottest
}:

buildPythonPackage rec {
  pname = "graphene";
<<<<<<< HEAD
  version = "3.3.0";
=======
  version = "3.2.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "graphene";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-DGxicCXZp9kW/OFkr0lAWaQ+GaECx+HD8+X4aW63vgQ=";
=======
    hash = "sha256-kwF6oXp06w7r1PbPoJTCQ9teTExYMoqvIZDhtv5QNn8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aniso8601
    graphql-core
    graphql-relay
  ];

  nativeCheckInputs = [
    promise
    py
    pytestCheckHook
    pytest-asyncio
    pytest-benchmark
    pytest-mock
    pytz
    snapshottest
  ];

  pytestFlagsArray = [
    "--benchmark-disable"
  ];

  pythonImportsCheck = [
    "graphene"
  ];

  meta = with lib; {
    description = "GraphQL Framework for Python";
    homepage = "https://github.com/graphql-python/graphene";
    changelog = "https://github.com/graphql-python/graphene/releases/tag/v${version}";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
