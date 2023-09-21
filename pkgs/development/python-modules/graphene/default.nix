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
  version = "3.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "graphene";
    rev = "refs/tags/v${version}";
    hash = "sha256-DGxicCXZp9kW/OFkr0lAWaQ+GaECx+HD8+X4aW63vgQ=";
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
    maintainers = with maintainers; [ ];
  };
}
