{ lib
, aniso8601
, buildPythonPackage
, fetchpatch
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

  patches = [
    # Fix graphql-core 3.2.0 support
    (fetchpatch {
      # https://github.com/graphql-python/graphene/pull/1378
      url = "https://github.com/graphql-python/graphene/commit/989970f89341ebb949962d13dcabca8a6ccddad4.patch";
      hash = "sha256-qRxWTqv5XQN7uFjL2uv9NjTvSLi76/MyFSa4jpkb8to=";
    })
    (fetchpatch {
      # https://github.com/graphql-python/graphene/pull/1417
      url = "https://github.com/graphql-python/graphene/commit/4e0e18d1682b7759bdf16499c573f675c7fb51cb.patch";
      hash = "sha256-icdTGDabJouQ3hVpcMkkeabNwdoDxdVVAboTOWFbO94=";
    })
  ];

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
    # https://github.com/graphql-python/graphene/pull/1417#issuecomment-1102492138
    "test_example_end_to_end"
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
