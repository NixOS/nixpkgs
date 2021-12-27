{ lib
, buildPythonPackage
, fetchFromGitHub
, aniso8601
, graphql-core
, graphql-relay
, promise
, pytestCheckHook
, pytest-asyncio
, pytest-benchmark
, pytest-mock
, pytz
, snapshottest
}:

buildPythonPackage rec {
  pname = "graphene";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "graphene";
    rev = "v${version}";
    sha256 = "0qgp3nl6afyz6y27bw175hyqppx75pp1vqwl7nvlpwvgwyyc2mnl";
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

  pytestFlagsArray = [ "--benchmark-disable" ];

  disabledTests = [
    # Expects different Exeception classes, but receives none of them
    # https://github.com/graphql-python/graphene/issues/1346
    "test_unexpected_error"
  ];

  pythonImportsCheck = [ "graphene" ];

  meta = with lib; {
    description = "GraphQL Framework for Python";
    homepage = "https://github.com/graphql-python/graphene";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
