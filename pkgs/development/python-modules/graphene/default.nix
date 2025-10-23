{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  graphql-core,
  graphql-relay,
  pytest-asyncio,
  pytest-benchmark,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "graphene";
  version = "3.4.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "graphene";
    tag = "v${version}";
    hash = "sha256-K1IGKK3nTsRBe2D/cKJ/ahnAO5xxjf4gtollzTwt1zU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    graphql-core
    graphql-relay
    python-dateutil
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-benchmark
    pytest-mock
  ];

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "graphene" ];

  meta = with lib; {
    description = "GraphQL Framework for Python";
    homepage = "https://github.com/graphql-python/graphene";
    changelog = "https://github.com/graphql-python/graphene/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
