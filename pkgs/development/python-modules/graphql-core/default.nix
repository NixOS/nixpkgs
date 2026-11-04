{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  anyio,
  pytest-describe,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "graphql-core";
  version = "3.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "graphql-core";
    tag = "v${version}";
    hash = "sha256-oQwWSLt2KqFSYzsBNdavo51XBuYhXh3R4VrS7EO8gUU=";
  };

  postPatch = ''
    # avoid big pytest-benchmark dependency
    substituteInPlace pyproject.toml \
      --replace-fail "addopts = \"--benchmark-disable\"" "" \
      --replace-fail "uv_build>=0.12,<0.13" "uv_build"
  '';

  build-system = [
    uv-build
  ];

  nativeCheckInputs = [
    anyio
    pytest-asyncio
    pytest-describe
    pytest-timeout
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
