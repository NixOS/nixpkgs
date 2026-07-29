{
  buildPythonPackage,
  cacert,
  dirty-equals,
  docker,
  fetchFromGitHub,
  granian,
  httpx,
  lib,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  requests-toolbelt,
  rustPlatform,
  starlette,
  syrupy,
  trustme,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyreqwest";
  version = "0.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MarkusSintonen";
    repo = "pyreqwest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MzcHdBMrOzkEDDtLS4dQaTv4Y8svK1aIfEmpTN3jzQQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-PxMKkKzSra3+d6BkaFzN/Ba2R1qOLJgCC60nrEHLdqY=";
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [ "pyreqwest" ];

  nativeCheckInputs = [
    cacert
    dirty-equals
    docker
    granian
    httpx
    pydantic
    pytest-asyncio
    pytestCheckHook
    requests-toolbelt
    starlette
    syrupy
    trustme
    yarl
  ];

  disabledTests = [
    # snapshot has different dict key ordering
    "test_assert_called_exact_count_failure"
    "test_assert_called_regex_matchers_display"
  ];

  disabledTestPaths = [
    # requires a running Docker daemon
    "tests/test_examples.py"
  ];

  meta = {
    changelog = "https://github.com/MarkusSintonen/pyreqwest/releases/tag/${finalAttrs.src.tag}";
    description = "Fast Python HTTP client based on Rust reqwest";
    homepage = "https://github.com/MarkusSintonen/pyreqwest";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
