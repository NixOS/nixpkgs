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
, fetchpatch
}:

buildPythonPackage rec {
  pname = "graphene";
  version = "3.0.0b7";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "graphene";
    rev = "v${version}";
    sha256 = "sha256-bVCCLPnV5F8PqLMg3GwcpwpGldrxsU+WryL6gj6y338=";
  };

  patches = [ (fetchpatch {
    # Allow later aniso8601 releases, https://github.com/graphql-python/graphene/pull/1331
    url = "https://github.com/graphql-python/graphene/commit/26b16f75b125e35eeb2274b7be503ec29f2e8a45.patch";
    sha256 = "qm96pNOoxPieEy1CFZpa2Mx010pY3QU/vRyuL0qO3Tk=";
  }) ];

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
