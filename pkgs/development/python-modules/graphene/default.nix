{ lib
, aniso8601
, buildPythonPackage
, fetchFromGitHub
, graphql-core
, graphql-relay
, promise
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
  version = "3.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "graphene";
    rev = "refs/tags/v${version}";
    hash = "sha256-XnrzgPkkFsTgNE9J+eSkD8f5MokKjtZhbbE/dxNZryk=";
  };

  propagatedBuildInputs = [
    aniso8601
    graphql-core
    graphql-relay
  ];

  checkInputs = [
    promise
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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
