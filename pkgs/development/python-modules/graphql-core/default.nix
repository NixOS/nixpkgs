{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  poetry-core,
  pytest-describe,
  anyio,
  pytest-aio,
  pytest-timeout,
  pytest-benchmark,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "graphql-core";
  version = "3.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "graphql-core";
    tag = "v${version}";
    hash = "sha256-bn3Am0ulF1zD5dwFkuXBfxSc46CxUBKwTmCEl7SqAuM=";
  };

  build-system = [
    uv-build
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytest-aio
    anyio
    pytest-benchmark
    pytest-describe
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/benchmarks"
  ];

  pythonImportsCheck = [ "graphql" ];

  meta = {
    changelog = "https://github.com/graphql-python/graphql-core/releases/tag/${src.tag}";
    description = "Port of graphql-js to Python";
    homepage = "https://github.com/graphql-python/graphql-core";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirdukkkkk ];
  };
}
