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
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

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

  pytestFlagsArray = [
    "--benchmark-disable"
  ];

  disabledTests = [
    # Expects different Exeception classes, but receives none of them
    # https://github.com/graphql-python/graphene/issues/1346
    "test_unexpected_error"
  ] ++ lib.optionals (pythonAtLeast "3.10") [
    "test_objecttype_as_container_extra_args"
    "test_objecttype_as_container_invalid_kwargs"
  ];

  pythonImportsCheck = [
    "graphene"
  ];

  meta = with lib; {
    description = "GraphQL Framework for Python";
    homepage = "https://github.com/graphql-python/graphene";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
