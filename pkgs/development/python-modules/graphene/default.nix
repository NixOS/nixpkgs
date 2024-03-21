{ lib
, aniso8601
, buildPythonPackage
, fetchFromGitHub
, setuptools
, graphql-core
, graphql-relay
, pytest-asyncio
, pytest-benchmark
, pytest-mock
, pytestCheckHook
, pythonOlder
, pytz
, snapshottest
}:

buildPythonPackage rec {
  pname = "graphene";
  version = "3.3.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "graphene";
    rev = "refs/tags/v${version}";
    hash = "sha256-DGxicCXZp9kW/OFkr0lAWaQ+GaECx+HD8+X4aW63vgQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aniso8601
    graphql-core
    graphql-relay
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-benchmark
    pytest-mock
    pytz
    snapshottest
  ];

  pytestFlagsArray = [
    "--benchmark-disable"
    "-W ignore::pytest.PytestRemovedIn8Warning"
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
